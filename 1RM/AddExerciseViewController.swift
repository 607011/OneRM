/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit


class AddExerciseViewController: UIViewController {

    @IBOutlet weak var newExerciseField: UITextField!

    var currentExercise: String?

    @IBAction func saveExercise(_ sender: Any) {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        guard let caller = viewControllers[viewControllers.count - 2] as? ExercisesTableViewController else { return }
        if let newExercise = newExerciseField.text {
            guard !newExercise.isEmpty else { return }
            if currentExercise != nil {
                if let idx = caller.exercises.firstIndex(of: currentExercise!) {
                    caller.exercises[idx] = newExerciseField.text!
                }
            }
            else {
                caller.exercises.append(newExercise)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelAddExercise(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newExerciseField.text = currentExercise ?? ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentExercise = nil
    }

}
