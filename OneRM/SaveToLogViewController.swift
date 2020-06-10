// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class SaveToLogViewController: UITableViewController {

    @IBOutlet weak var exercisePicker: UIPickerView!
    @IBOutlet weak var repsAndWeightLabel: UILabel!
    @IBOutlet weak var oneRMLabel: UILabel!
    @IBOutlet var starButton: [UIButton]!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!

    private var exercises: [Exercise] = []
    private var exercise: Exercise? {
        didSet {
            NSUbiquitousKeyValueStore.default.set(exercise?.name, forKey: Key.lastSavedExercise.rawValue)
        }
    }
    private var date: Date? {
        didSet {
            NSUbiquitousKeyValueStore.default.set(date, forKey: Key.lastSaveDate.rawValue)
        }
    }
    private var notes: String? {
        didSet {
            NSUbiquitousKeyValueStore.default.set(notes, forKey: Key.lastSaveNotes.rawValue)
        }
    }
    private var rating: Int = 0 {
        didSet {
            NSUbiquitousKeyValueStore.default.set(rating, forKey: Key.lastSaveRating.rawValue)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFromDefaults),
            name: UserDefaults.didChangeNotification,
            object: nil)
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
        if NSUbiquitousKeyValueStore.default.object(forKey: Key.lastSaveDate.rawValue) != nil {
            guard let lastDate = NSUbiquitousKeyValueStore.default.object(forKey: Key.lastSaveDate.rawValue) as? Date else { return }
            datePicker.date = lastDate
        }
        if NSUbiquitousKeyValueStore.default.object(forKey: Key.lastSaveNotes.rawValue) != nil {
            guard let lastNotes = NSUbiquitousKeyValueStore.default.string(forKey: Key.lastSaveNotes.rawValue) else { return }
            notesTextView.text = lastNotes
        }
        if NSUbiquitousKeyValueStore.default.object(forKey: Key.lastSaveRating.rawValue) != nil {
            rating = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.lastSaveRating.rawValue))
        }
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
                title: NSLocalizedString("Cancel", comment: ""),
                style: .cancel,
                handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        exercisePicker.reloadAllComponents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            guard let unit = LiftDataManager.shared.load(unitWithName: self.massUnit),
                !self.exercises.isEmpty else { return }
            let liftData = LiftData(
                date: self.datePicker.date,
                reps: Int16(self.reps),
                weight: self.weight,
                oneRM: self.oneRM,
                rating: Int16(self.rating),
                notes: self.notesTextView.text,
                exercise: self.exercise ?? self.exercises[0],
                unit: unit)
            try? LiftDataManager.shared.save(lift: liftData)
        case "gotoExercises": break
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
