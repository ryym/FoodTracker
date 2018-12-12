//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by ryu on 2018/12/05.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    // MARK: Meal Class Tests

    func testMealInitializationSucceeds() {
        let zeroRatingMeal = Meal(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)

        let positiveRatingMeal = Meal(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }

    func testMealInitializationFails() {
        let negativeRatingMeal = Meal(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)

        let largeRatingMeal = Meal(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)

        let emptyNameMeal = Meal(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyNameMeal)
    }
}
