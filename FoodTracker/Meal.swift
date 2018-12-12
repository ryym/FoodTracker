//
//  Meal.swift
//  FoodTracker
//
//  Created by ryu on 2018/12/12.
//

import UIKit

class Meal {
    var name: String
    var photo: UIImage?
    var rating: Int

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
}
