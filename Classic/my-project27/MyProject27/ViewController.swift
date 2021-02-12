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
        case 0: drawRectangle()
        case 1: drawCircle()
        case 2: drawCheckerboard()
        default: break
        }
    }

    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { context in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)

            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)

            context.cgContext.addRect(rectangle)
            context.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = image
    }

    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { context in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
                .insetBy(dx: 5, dy: 5)

            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)

            context.cgContext.addEllipse(in: rectangle)
            context.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = image
    }

    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { context in
            context.cgContext.setFillColor(UIColor.black.cgColor)

            for row in 0..<8 {
                for col in 0..<8 {
                    if (row + col) % 2 == 0 {
                        context.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }

        imageView.image = image
    }
}
