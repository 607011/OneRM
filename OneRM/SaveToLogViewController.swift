/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class SaveToLogViewController: UIViewController {

    @IBOutlet weak var exercisePicker: UIPickerView!
    @IBOutlet weak var repsAndWeightField: UITextField!
    @IBOutlet var starButton: [UIButton]!
    @IBOutlet weak var notesTextView: UITextView!

    var exercises: [Exercise] = []
    var exercise: Exercise?
    var reps: Int = 0
    var massUnit: String = DefaultMassUnit
    var weight: Double = 0
    var oneRM: Double = 0
    var rating: Int = 0

    @IBAction func starButtonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        rating = (button.tag == 1 && rating == 1) ? 0 : button.tag
        for i in 0..<rating {
            starButton[i].setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        for i in rating..<starButton.count {
            starButton[i].setImage(UIImage(systemName: "star"), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        exercisePicker.delegate = self
        exercisePicker.dataSource = self
        for (idx, button) in starButton.enumerated() {
            button.tag = idx + 1
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        massUnit = UserDefaults.standard.string(forKey: MassUnitKey) ?? DefaultMassUnit
        exercises = LiftDataManager.shared.loadExercises()
        repsAndWeightField.text = "\(reps) × \(weight.rounded(toPlaces: 1)) \(massUnit) ≈ \(oneRM.rounded(toPlaces: 1)) \(massUnit) 1RM"
        if UserDefaults.standard.object(forKey: LastSavedExerciseKey) != nil {
            let lastSavedExercise = UserDefaults.standard.string(forKey: LastSavedExerciseKey)
            guard let idx = exercises.firstIndex(where: { $0.name == lastSavedExercise }) else { return }
            exercisePicker.selectRow(idx, inComponent: 0, animated: false)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoLog" {
            /// XXX: what if the view segued into appears before the request has finished? Is this possible or not?
            DispatchQueue.main.async {
                guard let unit = LiftDataManager.shared.load(unitWithName: self.massUnit),
                    !self.exercises.isEmpty else { return }
                let liftData = LiftData(
                    date: Date(),
                    reps: Int16(self.reps),
                    weight: self.weight,
                    oneRM: self.oneRM,
                    rating: Int16(self.rating),
                    notes: self.notesTextView.text,
                    exercise: self.exercise ?? self.exercises[0],
                    unit: unit)
                try? LiftDataManager.shared.save(lift: liftData)
            }
        }
    }

}


extension SaveToLogViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        exercise = exercises[row]
        UserDefaults.standard.set(exercise?.name, forKey: LastSavedExerciseKey)
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
