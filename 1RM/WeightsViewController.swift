/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class WeightsViewController: UITableViewController {

    @IBOutlet weak var barWeightTextField: UITextField!
    @IBOutlet weak var massUnitLabel: UILabel!

    private var allowedCharacters = CharacterSet.decimalDigits


    private var plates: [Double] = DefaultPlates {
        didSet {
            UserDefaults.standard.set(plates, forKey: PlatesKey)
        }
    }

    var barWeight: Double = DefaultBarWeight {
        didSet {
            UserDefaults.standard.set(barWeight, forKey: BarWeightKey)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.insertSections(IndexSet(), with: .automatic)
        allowedCharacters.insert(charactersIn: Locale.current.decimalSeparator ?? ".,")
        barWeightTextField.delegate = self
        plates = UserDefaults.standard.object(forKey: PlatesKey) as? [Double] ?? DefaultPlates
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let barWeight = UserDefaults.standard.double(forKey: BarWeightKey)
        barWeightTextField.text = "\(barWeight.rounded(toPlaces: 2))"
        massUnitLabel.text = UserDefaults.standard.string(forKey: MassUnitKey) ?? DefaultMassUnit
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0: return 1
//        case 1: return 1
//        default: return 0
//        }
//    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return PlateTableViewCell()
//    }
}

extension WeightsViewController /* : UITableViewDelegate */ {
}


extension WeightsViewController /* : UITableViewDataSource */ {
}


extension WeightsViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == barWeightTextField {
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        barWeight = Double(barWeightTextField.text ?? "\(DefaultBarWeight)") ?? DefaultBarWeight
    }
}
