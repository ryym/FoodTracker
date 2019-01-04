//
//  Meal.swift
//  FoodTracker
//
//  Created by ryu on 2018/12/12.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    // MARK: Properties

    var name: String
    var photo: UIImage?
    var rating: Int

    // MARK: Archiving Paths
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("meals ")

    // MARK: Types

    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }

    // `?` indicates that this is a failable initializer.
    init?(name: String, photo: UIImage?, rating: Int) {
        guard !name.isEmpty else {
            return nil
        }

        guard 0 <= rating && rating <= 5 else {
            return nil
        }

        self.name = name
        self.photo = photo
        self.rating = rating
    }

    // MARK: NSCoding

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
    }

    // `convenience` means that this is a secondary initializer, and that
    // it must call a designated initializer from the same class.
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object", log: .default, type: .debug)
            return nil
        }

        let photo = decoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = decoder.decodeInteger(forKey: PropertyKey.rating)

        self.init(name: name, photo: photo, rating: rating)
    }
}
