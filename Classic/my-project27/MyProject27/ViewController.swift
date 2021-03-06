//
//  ViewController.swift
//  MyProject27
//
//  Created by Viktor Khotimchenko on 2021-02-12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currenDrawType = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        draw()
    }

    @IBAction func onRedrawButtonTap(_ sender: UIButton) {
        currenDrawType += 1
        if currenDrawType > 5 { currenDrawType = 0 }
        draw()
    }

    func draw() {
        switch currenDrawType {
        case 0: drawRectangle()
        case 1: drawCircle()
        case 2: drawCheckerboard()
        case 3: drawRotatedRectangles()
        case 4: drawLines()
        case 5: drawImagesAndText()
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

    func drawRotatedRectangles() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { context in
            context.cgContext.translateBy(x: 256, y: 256)

            let rotations = 16
            let amount = Double.pi / Double(rotations)

            for _ in 0..<rotations {
                context.cgContext.rotate(by: CGFloat(amount))
                context.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }

            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }

        imageView.image = image
    }

    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { context in
            context.cgContext.translateBy(x: 256, y: 256)

            var length: CGFloat = 256

            // do first loop manually because it has custom .move logic
            context.cgContext.rotate(by: .pi / 2)
            context.cgContext.move(to: CGPoint(x: length, y: 50))
            length *= 0.99

            for _ in 1..<256 {
                context.cgContext.rotate(by: .pi / 2)
                context.cgContext.addLine(to: CGPoint(x: length, y: 50))
                length *= 0.99
            }

//            var first = true
//            for _ in 0..<256 {
//                context.cgContext.rotate(by: .pi / 2)
//
//                if first {
//                    first = false
//                    context.cgContext.move(to: CGPoint(x: length, y: 50))
//                } else {
//                    context.cgContext.addLine(to: CGPoint(x: length, y: 50))
//                }
//
//                length *= 0.99
//            }

            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }

        imageView.image = image
    }

    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { _ in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle,
            ]

            let string = """
            The best-laid schemes o'
            mice an' men gang aft agley
            """

            let attributesString = NSAttributedString(string: string, attributes: attributes)
            attributesString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)

            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }

        imageView.image = image
    }
}
