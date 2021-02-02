//
//  ViewController.swift
//  MyProject5
//
//  Created by Viktor Khotimchenko on 2021-02-01.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer))

        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: .newlines)
            }
        }

        if allWords.isEmpty {
            allWords = ["mekmek"]
        }
        startGame()
    }

    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    // bugfix
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer",
                                   message: nil,
                                   preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(
            title: "Submit",
            style: .default) { [weak self, weak ac] _ in
                guard let answer = ac?.textFields?[0].text else { return }
                self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ rawAnswer: String) {
        let answer = rawAnswer.lowercased()
        if isPossible(word: answer) && isOriginal(word: answer) && isReal(word: answer) {
            usedWords.insert(answer, at: 0)

            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

    func isOriginal(word: String) -> Bool {
        true
    }

    func isPossible(word: String) -> Bool {
        true
    }

    func isReal(word: String) -> Bool {
        true
    }
}
