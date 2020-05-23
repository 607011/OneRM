/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class ExercisesTableViewController: UITableViewController {

    var exercises: [Exercise] = []
    var lifts: [Lift] = []
    var currentExercise: Exercise?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isEditing = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentExercise = nil
        exercises = LiftDataManager.shared.loadExercises()
        lifts = LiftDataManager.shared.loadLifts()
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LiftDataManager.shared.save()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EditExerciseViewController
        switch segue.identifier {
        case "addExercise":
            destination.currentExercise = nil
        case "editExercise":
            destination.currentExercise = currentExercise
        default: break
        }
    }

}

extension ExercisesTableViewController {
    func updateExerciseOrder() -> Void {
        for (idx, exercise) in exercises.enumerated() {
            exercise.order = Int16(idx)
        }
    }
}

extension ExercisesTableViewController {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.tableView != nil else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseTableViewCell
        cell.exerciseLabel.text = exercises[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedExercise = self.exercises[sourceIndexPath.row]
        exercises.remove(at: sourceIndexPath.row)
        exercises.insert(movedExercise, at: destinationIndexPath.row)
        updateExerciseOrder()
        LiftDataManager.shared.save()
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {  (contextualAction, view, boolValue) in
            let removedExercise = self.exercises[indexPath.row]

            func deleteInstantly() {
                LiftDataManager.shared.mainContext.delete(removedExercise)
                self.exercises.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                LiftDataManager.shared.save()
            }

            if self.lifts.contains(where: { $0.exercise == removedExercise }) {
                let alertController = UIAlertController(title: NSLocalizedString("Really delete exercise?", comment: ""), message: NSLocalizedString("There are lifts that refer to this exercise. Deleting the exercise will delete all associated lifts in your log. Do you really want to delete this exercise? ", comment: ""), preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { action in
                    self.tableView.reloadRows(at: [indexPath], with: .right)
                })
                let okAction = UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .destructive, handler: { action in
                    deleteInstantly()
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                alertController.preferredAction = cancelAction
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                deleteInstantly()
            }
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        let editAction = UIContextualAction(style: .normal, title: "edit") {  (contextualAction, view, boolValue) in
            self.currentExercise = self.exercises[indexPath.row]
            self.performSegue(withIdentifier: "editExercise", sender: self)
        }
        editAction.backgroundColor = .systemGreen
        editAction.image = UIImage(systemName: "square.and.pencil")
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeActions
    }
}
