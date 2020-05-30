// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class PercentagesViewController: UITableViewController {

    private var massUnit: String = defaultMassUnit
    private var weight: Double = 0
    private var reps: Int = 0
    private var orm: Double = 0
    private var maxPercent: Int = defaultMaxPercent
    private var minPercent: Int = defaultMinPercent
    private var percentStep: Int = defaultPercentStep
    private var formula: OneRMFormula = Brzycki()

    @objc func updateFromDefaults(notification: Notification) {
        guard let defaults = notification.object as? UserDefaults else { return }
        massUnit = defaults.string(forKey: Key.massUnit.rawValue) ?? defaultMassUnit
        formula = currentFormula()
        orm = formula.oneRM(weight: weight, reps: reps)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFromDefaults), name: UserDefaults.didChangeNotification, object: nil)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        massUnit = UserDefaults.standard.string(forKey: Key.massUnit.rawValue) ?? defaultMassUnit
        weight = NSUbiquitousKeyValueStore.default.double(forKey: Key.weight.rawValue)
        reps = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.reps.rawValue))
        maxPercent = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.maxPercent.rawValue))
        minPercent = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.minPercent.rawValue))
        percentStep = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.percentStep.rawValue))
        formula = currentFormula()
        orm = formula.oneRM(weight: weight, reps: reps)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int((maxPercent - minPercent) / percentStep) + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.tableView != nil else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "percentageCell", for: indexPath) as? PercentageTableViewCell {
            cell.massUnitLabel.text = massUnit
            let pct = maxPercent - indexPath.row * percentStep
            cell.percentageLabel.text = "\(pct)%"
            cell.weightLabel.text = "\((orm * Double(pct) * 1e-2).rounded(toPlaces: 1))"
            return cell
        }
        return UITableViewCell()
    }
}
