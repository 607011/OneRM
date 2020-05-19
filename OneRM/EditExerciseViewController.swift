/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit
import CoreData

class EditExerciseViewController: UIViewController {

    @IBOutlet weak var exerciseField: UITextField!

    var currentExercise: Exercise?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exerciseField.text = currentExercise?.name
        debugPrint("AddExerciseViewController.viewWillAppear()")
        self.title = (exerciseField.text == "")
            ? "Add exercise"
            : "Edit exercise"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("AddExerciseViewController.viewWillDisappear()")
        currentExercise = nil
        exerciseField.text = ""
    }

    @IBAction func saveExercise(_ sender: Any) {
//        guard let viewControllers = self.navigationController?.viewControllers else { return }
//        guard let caller = viewControllers[viewControllers.count - 2] as? ExercisesTableViewController else { return }
//        if let newExercise = exerciseField.text {
//            if !newExercise.isEmpty {
//                caller.updateExercise(newExercise)
//            }
//        }
        currentExercise?.name = exerciseField.text ?? ""
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelAddExercise(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
