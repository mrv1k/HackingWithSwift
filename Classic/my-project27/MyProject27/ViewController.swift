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

    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { (context) in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)

            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)

            context.cgContext.addRect(rectangle)
            context.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = image
    }
}
