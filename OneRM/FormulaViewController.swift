// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class FormulaTableViewController: UITableViewController {

    var formulas: [Formula] = defaultFormulas.keys.map({ $0 }).sorted(by: { $0.rawValue < $1.rawValue })

    var activeFormulas: [String] = [] {
        didSet {
            UserDefaults.standard.set(activeFormulas, forKey: Key.formulas.rawValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if UserDefaults.standard.object(forKey: Key.formulas.rawValue) != nil {
            activeFormulas = UserDefaults.standard.object(forKey: Key.formulas.rawValue) as? [String] ?? [Formula.brzycki.rawValue]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

extension FormulaTableViewController {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formulas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.tableView != nil else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "formulaCell", for: indexPath) as? FormulaTableViewCell {
            cell.formulaLabel.text = formulas[indexPath.row].rawValue
            cell.formulaSwitch.isOn = activeFormulas.contains(formulas[indexPath.row].rawValue)
            cell.formulaSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension FormulaTableViewController {
    @objc func switchChanged(sender formulaSwitch: UISwitch) {
        guard let cell = formulaSwitch.superview?.superview as? FormulaTableViewCell else { return }
        guard let formula = cell.formulaLabel.text else { return }
        if formulaSwitch.isOn {
            if !activeFormulas.contains(formula) {
                activeFormulas.append(formula)
            }
        } else {
            activeFormulas.removeAll(where: { $0 == formula })
        }
    }
}
