// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(managedObjectContextChanged),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: LiftDataManager.shared.mainContext)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "logEntryCell", for: indexPath) as? LogTableViewCell {
            cell.lift =  LiftData(from: lifts[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {  (_, _, _) in
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
