//
//  ViewController.swift
//  MyProject13
//
//  Created by Viktor Khotimchenko on 2021-02-07.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    var currentImage: UIImage!

    var context: CIContext!
    var currentFilter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(importPicture))

        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        self.imageView.alpha = 0
        // project 15/2: Go back to project 13 and make the image view fade in when a new picture is chosen. To make this work, set the alpha to 0 first.
        currentImage = image
        UIView.animate(withDuration: 1, delay: 0.5) {
            self.imageView.alpha = 1
        }

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        let filters = ["CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CISepiaTone",
                       "CITwirlDistortion", "CIUnsharpMask", "CIVignette"]

        // 2. Make the Change Filter button change its title to show the name of the currently selected filter.
        let ac = UIAlertController(title: "Choose Filter", message: "Currently selected: \(currentFilter.name)", preferredStyle: .actionSheet)

        filters.forEach { filter in
            ac.addAction(UIAlertAction(title: filter, style: .default, handler: setFilter))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }

        present(ac, animated: true)
    }

    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }

        currentFilter = CIFilter(name: actionTitle)

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    @IBAction func save(_ sender: Any) {
        // 1. Try making the Save button show an error if there was no image in the image view.
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "No image selected", message: "Please select an image before applying a filter", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }

        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }

        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }

        if inputKeys.contains(kCIInputCenterKey) {
            let vector = CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2)
            currentFilter.setValue(vector, forKey: kCIInputCenterKey)
        }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let ac: UIAlertController
        if let error = error {
            ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
        } else {
            ac = UIAlertController(title: "Saved", message: "Your altered image has been saved to your photos", preferredStyle: .alert)
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

// 3. Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.
// skip
