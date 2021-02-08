//
//  ViewController.swift
//  MyProject2
//
//  Created by Viktor Khotimchenko on 2021-01-28.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!

    var countries = [String]()
    var score = 0
    var questionsAsked = 0
    var correctAnswer = 0
    var previousCountryName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco",
                      "nigeria", "poland", "russia", "spain", "uk", "us"]
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion()
    }

    func askQuestion(action: UIAlertAction? = nil) {
        previousCountryName = countries[correctAnswer]
        // repeat shuffle until you get a country different from previous rounds
        repeat {
            countries.shuffle()
            correctAnswer = Int.random(in: 0 ... 2)
        } while countries[correctAnswer] == previousCountryName

        title = "Score: \(score) | \(countries[correctAnswer].uppercased())"
        questionsAsked += 1

        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            self.checkAnswer(sender)
        }
    }

    func checkAnswer(_ sender: UIButton) {
        var title: String

        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That’s the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }

        var ac: UIAlertController
        if questionsAsked == 10 {
            ac = UIAlertController(title: title,
                                   message: "Your final score is \(score) out of \(questionsAsked)",
                                   preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Start again",
                                       style: .default,
                                       handler: { _ in
                                           self.score = 0
                                           self.questionsAsked = 0
                                           self.askQuestion()
                                       }))
            ac.addAction(UIAlertAction(title: "Finish",
                                       style: .destructive,
                                       handler: { _ in
                                           self.title = "Your final score is \(self.score) out of \(self.questionsAsked)"
                                           self.button1.isEnabled = false
                                           self.button2.isEnabled = false
                                           self.button3.isEnabled = false
                                       }))

        } else {
            ac = UIAlertController(title: title,
                                   message: "Your score is \(score)",
                                   preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue",
                                       style: .default,
                                       handler: askQuestion))
        }

        present(ac, animated: true)
    }
}
