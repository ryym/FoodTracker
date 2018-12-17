//
//  MealViewController.swift
//  FoodTracker
//
//  Created by ryu on 2018/12/05.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var ratingControl: RatingControl!

    @IBOutlet weak var saveButton: UIBarButtonItem!

    var meal: Meal?

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self

        // Set up views if editing an existing meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }

        updateSaveButtonState()
    }

    // MARK: Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation),
        // this view controller needs to be dismissed in two different ways.
        // https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/ImplementEditAndDeleteBehavior.html#//apple_ref/doc/uid/TP40015214-CH9-SW1
        let isAddMealMode = presentingViewController is UINavigationController

        if isAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button is not pressed, cancelling", log: .default, type: .debug)
            return
        }

        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating

        meal = Meal(name: name, photo: photo, rating: rating)
    }

    // MARK: Actions

    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()

        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the save button while editing.
        saveButton.isEnabled = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    // MARK: UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // Called when a user selects a photo.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // The info dictionary may contain multiple representations of the image.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but whas provided the following: \(info)")
        }

        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

    private func updateSaveButtonState() {
        saveButton.isEnabled = !(nameTextField.text ?? "").isEmpty
    }
}

