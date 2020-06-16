// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class SaveToLogViewController: UITableViewController {

    @IBOutlet weak var exercisePicker: UIPickerView!
    @IBOutlet weak var repsAndWeightLabel: UILabel!
    @IBOutlet weak var oneRMLabel: UILabel!
    @IBOutlet var starButton: [UIButton]!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    private var exercises: [Exercise] = [] {
        didSet {
            exercisePicker.reloadAllComponents()
            saveButton.isEnabled = !exercises.isEmpty
        }
    }
    private var exercise: Exercise? {
        didSet {
            NSUbiquitousKeyValueStore.default.set(exercise?.name, forKey: Key.lastSavedExercise.rawValue)
        }
    }
    private var date: Date?
    private var notes: String?
    private var rating: Int = 0 {
        didSet {
            for i in 0..<rating {
                starButton[i].setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
            for i in rating..<starButton.count {
                starButton[i].setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    var reps: Int = 0
    var massUnit: String = defaultMassUnit
    var weight: Double = 0
    var oneRM: Double = 0

    @IBAction func starButtonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        rating = (button.tag == 1 && rating == 1) ? 0 : button.tag
    }

    @objc func updateFromDefaults(notification: Notification) {
        guard let defaults = notification.object as? UserDefaults else { return }
        massUnit = defaults.string(forKey: Key.massUnit.rawValue) ?? defaultMassUnit
        tableView.reloadData()
    }

    @objc func updateExercisePicker(_ notification: Notification) {
        exercises = LiftDataManager.shared.loadExercises()
        exercisePicker.reloadAllComponents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFromDefaults),
            name: UserDefaults.didChangeNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateExercisePicker),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: LiftDataManager.shared.mainContext)
        exercisePicker.delegate = self
        exercisePicker.dataSource = self
        for (idx, button) in starButton.enumerated() {
            button.tag = idx + 1
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        massUnit = UserDefaults.standard.string(forKey: Key.massUnit.rawValue) ?? defaultMassUnit
        exercises = LiftDataManager.shared.loadExercises()
        repsAndWeightLabel.text = "\(reps) × \(weight.rounded(toPlaces: 1)) \(massUnit)"
        oneRMLabel.text = "\(oneRM.rounded(toPlaces: 1)) \(massUnit)"
        weight = NSUbiquitousKeyValueStore.default.double(forKey: Key.weight.rawValue)
        reps = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.reps.rawValue))
        if NSUbiquitousKeyValueStore.default.object(forKey: Key.lastSavedExercise.rawValue) != nil {
            let lastSavedExercise = NSUbiquitousKeyValueStore.default.string(forKey: Key.lastSavedExercise.rawValue)
            guard let idx = exercises.firstIndex(where: { $0.name == lastSavedExercise }) else { return }
            exercisePicker.selectRow(idx, inComponent: 0, animated: false)
            exercise = exercises[idx]
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if exercises.isEmpty {
            let alertController = UIAlertController(
                title: NSLocalizedString("No exercises", comment: ""),
                message: NSLocalizedString(
                    """
        You haven't entered any exercises.
        Please go to Settings/Exercises to add an exercise,
        then come back here.
        """,
                    comment: ""),
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: NSLocalizedString("Take me there", comment: ""),
                style: .default,
                handler: { _ in
                    self.performSegue(withIdentifier: "gotoExercises", sender: nil)
            })
            let cancelAction = UIAlertAction(
                title: NSLocalizedString("Stay here", comment: ""),
                style: .cancel,
                handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        date = datePicker.date
        notes = notesTextView.text
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSUbiquitousKeyValueStore.default.synchronize()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "gotoLog":
            guard let unit = LiftDataManager.shared.load(unitWithName: self.massUnit) else {
                NSLog("Error: No units present while preparing for segue '\(segue.identifier!)'. This should not have happened.")
                return
            }
            guard !self.exercises.isEmpty else {
                NSLog("Error: No exercises presentwhile preparing for segue '\(segue.identifier!)'. This should not have happened.")
                return
            }
            let exercise = self.exercise ?? exercises[0]
            var date = datePicker.date
            if date < Date() { // reset time if selected date is in the past
                let calendar = Calendar.current
                var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond, .timeZone], from: date)
                dateComponents.hour = 0
                dateComponents.minute = 0
                dateComponents.second = 0
                dateComponents.nanosecond = 0
                date = calendar.date(from: dateComponents) ?? date
            }
            let liftData = LiftData(
                date: date,
                reps: Int16(reps),
                weight: weight,
                oneRM: oneRM,
                rating: Int16(rating),
                notes: notesTextView.text,
                exercise: exercise,
                unit: unit)
            try? LiftDataManager.shared.save(lift: liftData)
        case "gotoExercises": break // case explicitly listed to remind developer of all the possible segues in SaveToLogViewController ;-)
        default: break
        }
    }

}

extension SaveToLogViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        exercise = exercises[row]
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercises[row].name
    }
}

extension SaveToLogViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
