// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class EditExerciseViewController: UIViewController {

    @IBOutlet weak var exerciseField: UITextField!

    var currentExercise: Exercise?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exerciseField.text = currentExercise?.name
        exerciseField.becomeFirstResponder()
        self.title = (exerciseField.text == "")
            ? NSLocalizedString("Add exercise", comment: "")
            : NSLocalizedString("Edit exercise", comment: "")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentExercise = nil
        exerciseField.text = ""
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSUbiquitousKeyValueStore.default.synchronize()
    }

    @IBAction func saveExercise(_ sender: Any) {
        if currentExercise == nil {
            let exerciseData = ExerciseData(name: exerciseField.text ?? "", order: -1)
            // swiftlint:disable:next force_try
            try! LiftDataManager.shared.save(exercise: exerciseData)
        } else {
            currentExercise!.name = exerciseField.text ?? ""
            LiftDataManager.shared.save()
        }
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelAddExercise(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
