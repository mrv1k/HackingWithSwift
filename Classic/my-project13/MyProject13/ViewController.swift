//
//  ViewController.swift
//  MyProject13
//
//  Created by Viktor Khotimchenko on 2021-02-07.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeFilter(_ sender: Any) {}

    @IBAction func save(_ sender: Any) {}

    @IBAction func intensityChanged(_ sender: Any) {}
}
