/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class PercentagesViewController: UITableViewController {

    var massUnit: String = DefaultMassUnit
    var weight: Double = 0
    var reps: Int = 0
    var orm: Double = 0

    let maxPercentage: Int = 120
    let minPercentage: Int = 5
    let percentageStep: Int = 5

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
        orm = brzycki(weight: weight, reps: reps)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int((maxPercentage - minPercentage) / percentageStep)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.tableView != nil else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "percentageCell", for: indexPath) as! PercentageTableViewCell
        cell.massUnitLabel.text = massUnit
        let pct = maxPercentage - indexPath.row * percentageStep
        cell.percentageLabel.text = "\(pct)%"
        cell.weightLabel.text = "\((orm * Double(pct) * 1e-2).rounded(toPlaces: 1))"
        return cell
    }
}
