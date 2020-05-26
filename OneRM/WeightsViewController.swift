// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class WeightsViewController: UITableViewController {

    @IBOutlet weak var barWeightTextField: UITextField!
    @IBOutlet weak var massUnitLabel: UILabel!

    private var allowedCharacters = CharacterSet.decimalDigits

    private var plates: [Double] = defaultPlates {
        didSet {
            UserDefaults.standard.set(plates, forKey: platesKey)
        }
    }

    var barWeight: Double = defaultBarWeight {
        didSet {
            UserDefaults.standard.set(barWeight, forKey: barWeightKey)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.insertSections(IndexSet(), with: .automatic)
        allowedCharacters.insert(charactersIn: Locale.current.decimalSeparator ?? ".,")
        barWeightTextField.delegate = self
        plates = UserDefaults.standard.object(forKey: platesKey) as? [Double] ?? defaultPlates
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let barWeight = UserDefaults.standard.double(forKey: barWeightKey)
        barWeightTextField.text = "\(barWeight.rounded(toPlaces: 2))"
        massUnitLabel.text = UserDefaults.standard.string(forKey: massUnitKey) ?? defaultMassUnit
    }
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
        barWeight = Double(barWeightTextField.text!)!
    }
}
