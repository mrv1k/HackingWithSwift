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
    var sourceWord = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer))

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(restart))


        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: .newlines)
            }
        }

        if allWords.isEmpty { allWords = ["mekmek"] }
        startGame()
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

    func startGame() {
        sourceWord = allWords.randomElement() ?? "congests"
        title = sourceWord

        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    @objc func restart() {
        startGame()
    }


    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer",
                                   message: nil,
                                   preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(
            title: "Submit",
            style: .default) { [weak self, weak ac] _ in
                guard let anagramAnswer = ac?.textFields?[0].text else { return }
                self?.submit(anagramAnswer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ rawAnagram: String) {
        let anagram = rawAnagram.lowercased()

        let validation = validate(anagram: anagram)

        guard validation == .valid else {
            return showErrorMessage(validation: validation)
        }

        // passed validation, safe to recort
        usedWords.insert(anagram, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func showErrorMessage(validation: WordValidation) {
        let ac = UIAlertController(
            title: validation.error.title, message: validation.error.message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func validate(anagram: String) -> WordValidation {
        guard !anagram.isEmpty else { return .empty }
        guard anagram.count > 2 else { return .tooShort }
        guard !sourceWord.starts(with: anagram) else { return .startPart }

        guard isPossible(word: anagram) else { return .notPossible }
        guard isOriginal(word: anagram) else { return .notOriginal }
        guard isReal(word: anagram) else { return .notReal(answer: anagram, sourceWord: sourceWord) }

        return .valid
    }

    func isPossible(word: String) -> Bool {
        var sourceWordCopy = sourceWord

        for letter in word {
            if let position = sourceWordCopy.firstIndex(of: letter) {
                sourceWordCopy.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }

    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
}

enum WordValidation: Equatable {
    case empty
    case tooShort
    case startPart
    case notPossible
    case notOriginal
    case notReal(answer: String, sourceWord: String)
    case valid

    var error: (title: String, message: String) {
        switch self {
        case .empty: return ("Word is missing", "Cannot be empty :(")
        case .tooShort: return ("Word is shorter than 3 letters", "Answers that are shorter than three letters.")
        case .startPart: return ("Word is a starting part", "Not an anagram, just a start part")
        case .notPossible: return ("Word not possible", "You can't just make them up, you know!")
        case .notOriginal: return ("Word already used", "Be more original!")
        case .notReal(let answer, let sourceWord):
            return ("Word not recognized", "You can't spell \"\(answer)\" from \"\(sourceWord)\".")
        case .valid: return ("", "")
        }
    }
}
