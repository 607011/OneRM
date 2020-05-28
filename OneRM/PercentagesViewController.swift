// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class PercentagesViewController: UITableViewController {

    var massUnit: String = defaultMassUnit
    var weight: Double = 0
    var reps: Int = 0
    var orm: Double = 0

    var maxPercent: Int = defaultMaxPercent
    var minPercent: Int = defaultMinPercent
    var percentStep: Int = defaultPercentStep
    var formula: OneRMFormula = Brzycki()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        massUnit = NSUbiquitousKeyValueStore.default.string(forKey: Key.massUnit.rawValue) ?? defaultMassUnit
        weight = NSUbiquitousKeyValueStore.default.double(forKey: Key.weight.rawValue)
        reps = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.reps.rawValue))
        maxPercent = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.maxPercent.rawValue))
        minPercent = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.minPercent.rawValue))
        percentStep = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.percentStep.rawValue))
        if NSUbiquitousKeyValueStore.default.object(forKey: Key.formulas.rawValue) != nil,
            let activeFormulas = NSUbiquitousKeyValueStore.default.object(forKey: Key.formulas.rawValue) as? [String] {
            formula = activeFormulas.isEmpty
                ? Brzycki()
                : MixedOneRM(formulas: activeFormulas)
        }
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
