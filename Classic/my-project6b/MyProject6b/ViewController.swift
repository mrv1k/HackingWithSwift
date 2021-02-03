//
//  ViewController.swift
//  MyProject6b
//
//  Created by Viktor Khotimchenko on 2021-02-02.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = .red
        label1.text = "HELLO"
        label1.sizeToFit()

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = .cyan
        label2.text = "DARKNESS"
        label2.sizeToFit()

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = .yellow
        label3.text = "MY"
        label3.sizeToFit()

        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = .green
        label4.text = "OLD"
        label4.sizeToFit()

        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = .orange
        label5.text = "FRIEND"
        label5.sizeToFit()

        let views = [label1, label2, label3, label4, label5]
        views.forEach { view.addSubview($0) }
//        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
//        viewsDictionary.values.forEach { view.addSubview($0) }
//
//        viewsDictionary.keys.forEach { key in
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(key)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
//
//        let metrics = ["labelHeight": 88]
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:
//            "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|",
//            options: [], metrics: metrics, views: viewsDictionary))

        var previous: UILabel?

        views
            .forEach { (label) in
                label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                label.heightAnchor.constraint(equalToConstant: 88).isActive = true

                if let previous = previous {
                    label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
                } else {
                    label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
                }

                previous = label
            }
    }
}
