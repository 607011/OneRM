/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class PercentagesViewController: UITableViewController {

    var massUnit: String = DefaultMassUnit
    var weight: Double = 0
    var reps: Int = 0
    var orm: Double = 0

    var maxPercent: Int = DefaultMaxPercent
    var minPercent: Int = DefaultMinPercent
    var percentStep: Int = DefaultPercentStep
    var formula: OneRMFormula = Brzycki()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        massUnit = UserDefaults.standard.string(forKey: MassUnitKey) ?? DefaultMassUnit
        weight = UserDefaults.standard.double(forKey: WeightKey)
        reps = UserDefaults.standard.integer(forKey: RepsKey)
        maxPercent = UserDefaults.standard.integer(forKey: MaxPercentKey)
        minPercent = UserDefaults.standard.integer(forKey: MinPercentKey)
        percentStep = UserDefaults.standard.integer(forKey: PercentStepKey)
        if UserDefaults.standard.object(forKey: FormulasKey) != nil {
            let activeFormulas = UserDefaults.standard.object(forKey: FormulasKey) as! [String]
            formula = MixedOneRM(formulas: activeFormulas.map({ Formula(rawValue: $0) ?? .brzycki }))
        }
        orm = formula.oneRM(weight: weight, reps: reps)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int((maxPercent - minPercent) / percentStep) + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.tableView != nil else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "percentageCell", for: indexPath) as! PercentageTableViewCell
        cell.massUnitLabel.text = massUnit
        let pct = maxPercent - indexPath.row * percentStep
        cell.percentageLabel.text = "\(pct)%"
        cell.weightLabel.text = "\((orm * Double(pct) * 1e-2).rounded(toPlaces: 1))"
        return cell
    }
}
