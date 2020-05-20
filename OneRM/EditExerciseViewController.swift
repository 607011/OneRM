/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit
import CoreData

class EditExerciseViewController: UIViewController {

    @IBOutlet weak var exerciseField: UITextField!

    var currentExercise: Exercise?
    lazy var appDelegate: AppDelegate? = {
        return UIApplication.shared.delegate as? AppDelegate
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exerciseField.text = currentExercise?.name
        self.title = (exerciseField.text == "")
            ? NSLocalizedString("Add exercise", comment: "")
            : NSLocalizedString("Edit exercise", comment: "")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentExercise = nil
        exerciseField.text = ""
    }

    @IBAction func saveExercise(_ sender: Any) {
        if currentExercise == nil {
            let exercise = Exercise(entity: Exercise.entity(), insertInto: appDelegate?.persistentContainer.viewContext)
            exercise.name = exerciseField.text ?? ""
        }
        else {
            currentExercise!.name = exerciseField.text ?? ""
        }
        appDelegate?.saveContext()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelAddExercise(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
