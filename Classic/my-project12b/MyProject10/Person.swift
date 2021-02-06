//
//  Person.swift
//  MyProject10
//
//  Created by Viktor Khotimchenko on 2021-02-05.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
