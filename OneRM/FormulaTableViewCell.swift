/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class FormulaTableViewCell: UITableViewCell {
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var formulaSwitch: UISwitch!

    @IBAction func switched(_ sender: Any) {
        guard let switchButton = sender as? UISwitch else { return }
        if switchButton == formulaSwitch {

        }
    }
}
