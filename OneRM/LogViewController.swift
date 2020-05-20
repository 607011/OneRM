/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class LogViewController: UITableViewController {

    var lifts: [Lift] = []

    @IBAction func refreshButtonPressed(_ sender: Any) {
        refreshUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextChanged), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: LiftDataManager.shared.mainContext)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }

}


extension LogViewController {
    func refreshUI() {
        lifts = LiftDataManager.shared.loadLifts()
        tableView.reloadData()
    }

    @objc
    func managedObjectContextChanged(notification: NSNotification) {
        if notification.name == .NSManagedObjectContextObjectsDidChange {
            refreshUI()
        }
    }
}

extension LogViewController {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lifts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.tableView != nil else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "logEntryCell", for: indexPath) as! LogTableViewCell
        let lift = lifts[indexPath.row]
        cell.exerciseLabel.text = lift.exercise.name
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Locale.current.calendar
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMYHm", options: 0, locale: Locale.current)
        cell.dateLabel.text = dateFormatter.string(from: lift.date)
        cell.oneRMLabel.text = "\(lift.oneRM.rounded(toPlaces: 1)) \(lift.unit.name) 1RM"
        cell.repsAndWeightLabel.text = "\(lift.reps) × \(lift.weight.rounded(toPlaces: 1)) \(lift.unit.name)"
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {  (contextualAction, view, boolValue) in
            let removedLift = self.lifts[indexPath.row]
            LiftDataManager.shared.mainContext.delete(removedLift)
            self.lifts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            LiftDataManager.shared.save()
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}
