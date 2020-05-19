/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit


class ExercisesTableViewController: UITableViewController {

    var exercises: [Exercise] = []
    var currentExercise: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isEditing = true
        exercises = LiftDataManager.shared.loadExercises()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        try! LiftDataManager.shared.save(exercises: exercises)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExercise" {
            let destination = segue.destination as! AddExerciseViewController
            destination.currentExercise = currentExercise
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

//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedExercise = self.exercises[sourceIndexPath.row]
        exercises.remove(at: sourceIndexPath.row)
        exercises.insert(movedExercise, at: destinationIndexPath.row)
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {  (contextualAction, view, boolValue) in
            self.exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        let editAction = UIContextualAction(style: .normal, title: "edit") {  (contextualAction, view, boolValue) in
            self.currentExercise = self.exercises[indexPath.row].name
            self.performSegue(withIdentifier: "addExercise", sender: self)
        }
        editAction.backgroundColor = .systemGreen
        editAction.image = UIImage(systemName: "square.and.pencil")
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeActions
    }
}


extension ExercisesTableViewController {
    func updateExercise(_ exercise: String) {
        if exercises.contains(where: { return $0.name == exercise }) {
            // TODO: replace
        }
        else {
            // TODO: add
        }
    }
}
