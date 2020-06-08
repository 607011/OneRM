// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

protocol LiftSelectionDelegate: class {
    func liftSelected(_ newLift: Lift)
}

class LogViewController: UITableViewController {

    let searchBarHeight: CGFloat = 44
    var lifts: [Lift] = []
    var selectedLift: Lift?
    var searchBar: UISearchBar?
    var searchBarVisible: Bool = false
    var searchTerm: String?

    @IBAction func searchButtonTapped(_ sender: Any) {
        toggleSearchBar()
    }

    weak var delegate: LiftSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(managedObjectContextChanged),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: LiftDataManager.shared.mainContext)
        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: searchBarHeight))
        searchBar?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar?.text = searchTerm
        refreshUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            LiftDataManager.shared.save()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if searchBarVisible && scrollView.contentOffset.y > searchBarHeight {
            hideSearchBar()
        } else if searchBarVisible == false && scrollView.contentOffset.y < searchBarHeight {
            showSearchBar()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoLogDetail" {
            guard let lift = selectedLift else { return }
            let dest = segue.destination as! LogDetailViewController // swiftlint:disable:this force_cast
            dest.lift = lift
        }
    }
}

extension LogViewController: UISearchBarDelegate {

    func hideSearchBar() {
        self.tableView.tableHeaderView = nil
        searchBarVisible = false
    }

    func showSearchBar() {
        searchBar?.becomeFirstResponder()
        self.tableView.tableHeaderView = searchBar
        searchBarVisible = true
    }

    func toggleSearchBar() {
        if searchBarVisible {
            hideSearchBar()
        } else {
            showSearchBar()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            lifts = LiftDataManager.shared.loadLifts()
            searchTerm = nil
        } else {
            lifts = LiftDataManager.shared.loadLifts(by: searchText)
            searchTerm = searchText
        }
        tableView.reloadData()
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLift = lifts[indexPath.row]
        performSegue(withIdentifier: "gotoLogDetail", sender: self)
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
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("delete", comment: "to delete")) {  (_, _, _) in
            let actionSheet = UIAlertController(
                title: NSLocalizedString("Really delete lift?", comment: ""),
                message: NSLocalizedString("Deletion of lift cannot be undone. Do you really want to delete it?", comment: ""),
                preferredStyle: .alert)
            let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: "answer Yes"), style: .destructive, handler: { _ in
                DispatchQueue.main.async {
                    let removedLift = self.lifts[indexPath.row]
                    LiftDataManager.shared.mainContext.delete(removedLift)
                    self.lifts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            })
            let noAction = UIAlertAction(title: NSLocalizedString("No", comment: "answer No"), style: .cancel, handler: { _ in
                self.tableView.reloadRows(at: [indexPath], with: .right)
            })
            actionSheet.addAction(noAction)
            actionSheet.addAction(yesAction)
            self.present(actionSheet, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}
