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

    var rating = 0

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
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()

        for _ in 0..<starCount {
            let button = UIButton()
            button.backgroundColor = UIColor.red

            // Add constraints.
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)

            addArrangedSubview(button)

            ratingButtons.append(button)
        }
    }

    // MARK: Button Action

    @objc func ratingButtonTapped(button: UIButton) {
        print("Button pressed :+1:")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
