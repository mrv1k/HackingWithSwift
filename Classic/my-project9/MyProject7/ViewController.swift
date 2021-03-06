//
//  ViewController.swift
//  MyProject7
//
//  Created by Viktor Khotimchenko on 2021-02-03.
//

import UIKit

class ViewController: UITableViewController {
    var allPetitions = [Petition]()

    var filterQuery = ""
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // if "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        // else "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"

        navigationItem.rightBarButtonItem = UIBarButtonItem(image:
            UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(showSearchAlert))

        // Bugfix:
        // -[UINavigationController tabBarItem] must be used from main thread only
        // UIViewController.navigationController must be used from main thread only
        let tag = navigationController?.tabBarItem.tag
        performSelector(inBackground: #selector(fetchJSON(tag:)), with: tag)
    }

    @objc func fetchJSON(tag: Int) {
        let urlString = tag == 0 ?
            "https://www.hackingwithswift.com/samples/petitions-1.json" :
            "https://www.hackingwithswift.com/samples/petitions-2.json"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }

        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    @objc func showSearchAlert() {
        let title = filterQuery.isEmpty ? "Filter by Title" : "Filtered by \"\(filterQuery)\""
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak self] (_: UIAlertAction) in
            guard let self = self else { return }
            guard let inputQuery = ac.textFields?.first?.text else { return }
            self.filterQuery = inputQuery
            DispatchQueue.global(qos: .background).sync {
                self.filteredPetitions = self.allPetitions.filter { (petition: Petition) -> Bool in
                    petition.title.lowercased().contains(inputQuery.lowercased())
                }
            }
            self.tableView.reloadData()
        }))

        ac.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { [weak self] (_: UIAlertAction) in
            guard let self = self else { return }
            self.filterQuery = ""
            self.filteredPetitions = self.allPetitions
            self.tableView.reloadData()
        }))

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }

    @objc func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed; please check your connection and try again. ",
            preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))

        present(ac, animated: true)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            filteredPetitions = jsonPetitions.results

//            UITableViewController.tableView must be used from main thread only
//                tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }

        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController()
        detailsVC.detailItem = allPetitions[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
