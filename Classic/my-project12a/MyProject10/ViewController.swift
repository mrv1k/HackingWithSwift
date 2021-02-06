//
//  ViewController.swift
//  MyProject10
//
//  Created by Viktor Khotimchenko on 2021-02-05.
//

import UIKit

class ViewController: UICollectionViewController,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell
        else { fatalError("Unable to deque reusable cell") }

        let person = people[indexPath.item]
        cell.name.text = person.name

        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)

        cell.imageView.layer.borderColor = UIColor.systemGray3.cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        return cell
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()

        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]

        let renameAC = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        renameAC.addTextField()

        renameAC.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak renameAC] _ in
            guard let self = self else { return }

            guard let newName = renameAC?.textFields?.first?.text else { return }
            person.name = newName
            self.collectionView.reloadData()
        }))

        renameAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        let menuAC = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        menuAC.addAction(UIAlertAction(title: "Rename", style: .default, handler: { _ in
            self.present(renameAC, animated: true)
        }))

        menuAC.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.people.remove(at: indexPath.item)
            self.collectionView.reloadData()
        }))

        present(menuAC, animated: true)
    }
}
