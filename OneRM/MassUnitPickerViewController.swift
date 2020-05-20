/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class MassUnitPickerViewController: UIViewController {

    @IBOutlet weak var massUnitPicker: UIPickerView!

    var units: [Unit] = []

    var massUnit: String = DefaultMassUnit {
        didSet {
            UserDefaults.standard.set(massUnit, forKey: MassUnitKey)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        massUnitPicker.delegate = self
        massUnitPicker.dataSource = self
        units = LiftDataManager.shared.loadUnits()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let massUnit = UserDefaults.standard.string(forKey: MassUnitKey) ?? DefaultMassUnit
        guard let row = DefaultUnits.firstIndex(of: massUnit) else { return }
        massUnitPicker.selectRow(row, inComponent: 0, animated: true)
    }
}


extension MassUnitPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        massUnit = units[row].name
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row].name
    }
}


extension MassUnitPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
