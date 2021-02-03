//
//  ViewController.swift
//  MyProject7
//
//  Created by Viktor Khotimchenko on 2021-02-03.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // if "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        // else "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"

        let urlString = navigationController?.tabBarItem.tag == 0 ?
            "https://www.hackingwithswift.com/samples/petitions-1.json" :
            "https://www.hackingwithswift.com/samples/petitions-2.json"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }

    func showError() {
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
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController()
        detailsVC.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
