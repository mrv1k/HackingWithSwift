//
//  ViewController.swift
//  MyProject27
//
//  Created by Viktor Khotimchenko on 2021-02-12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currenDrawType = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        drawRectangle()
    }

    @IBAction func onRedrawButtonTap(_ sender: UIButton) {
        currenDrawType += 1

        if currenDrawType > 5 {
            currenDrawType = 0
        }

        switch currenDrawType {
        case 0:
            drawRectangle()
        default:
            break
        }
    }

    func drawRectangle() {}
}
