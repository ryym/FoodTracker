//
//  RatingControl.swift
//  FoodTracker
//
//  Created by ryu on 2018/12/07.
//

import UIKit

// IBDesignable lets Interface Builder draw this control.
@IBDesignable class RatingControl: UIStackView {
    // MARK: Properties

    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }

    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }

    private var ratingButtons = [UIButton]()

    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }

    // MARK: Initialization

    // Called when programmatically initialized.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }

    // Called when loaded from the storyboard.
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    private func setupButtons() {
        // Load images.
        let bundle = Bundle(for: type(of: self))
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)

        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()

        for idx in 0..<starCount {
            let button = UIButton()

            // Set button images.
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])

            // Add constraints.
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

            button.accessibilityLabel = "Set \(idx + 1) star rating"

            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)

            addArrangedSubview(button)

            ratingButtons.append(button)
        }

        updateButtonSelectionStates()
    }

    private func updateButtonSelectionStates() {
        let valueString: String
        if rating == 0 {
            valueString = "No rating set."
        } else {
            valueString = "\(rating) \(rating == 1 ? "star" : "stars") set."
        }
        for (idx, button) in ratingButtons.enumerated() {
            button.isSelected = idx < rating
            button.accessibilityHint = idx + 1 == rating ? "Tap to reset the rating to the zero." : nil
            button.accessibilityValue = valueString
        }
    }

    // MARK: Button Action

    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button \(button), is not in the ratingButtons array: \(ratingButtons)")
        }

        let selectedRating = index + 1
        rating = selectedRating == rating ? 0 : selectedRating
    }
}
