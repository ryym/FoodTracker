//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by ryu on 2018/12/15.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    // MARK: Properties

    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            loadSampleMeals()
        }
    }

    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")

        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }

        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }

        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }

        meals += [meal1, meal2, meal3]
    }

    private func saveMeals() {
        do {
            try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
            os_log("Meals successfully saved", log: .default, type: .error)
        } catch {
            os_log("Failed to save meals...", log: .default, type: .error)
        }
    }

    private func loadMeals() -> [Meal]? {
        // `unarchiveObject` is deprecated but I could not find an alternative way to
        // load and unarchive data from a file.
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Our meal table view is simple and has a single section.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in a given section.
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are resued and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"

        let dequeued = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let cell = dequeued as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }

        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal", log: .default, type: .debug)

        case "ShowDetail":
            guard let mealViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "no sender")")
            }

            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedMeal = meals[indexPath.row]
            mealViewController.meal = selectedMeal

        default:
            fatalError("Unexpected segue identifier: \(segue.identifier ?? "no identifier")")
        }
    }

    // MARK: Actions

    // Called when a user taps the Save button in the meal detail view.
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let source = sender.source as? MealViewController, let meal = source.meal {
            // If a user are editing an existing meal, a corresponding row must be selected.
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

            saveMeals()
        }
    }
}
