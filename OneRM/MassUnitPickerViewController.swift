// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class MassUnitPickerViewController: UIViewController {

    @IBOutlet weak var massUnitPicker: UIPickerView!

    private var units: [Unit] = []

    private var massUnit: String = defaultMassUnit {
        didSet {
            NSUbiquitousKeyValueStore.default.set(massUnit, forKey: Key.massUnit.rawValue)
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
        let massUnit = NSUbiquitousKeyValueStore.default.string(forKey: Key.massUnit.rawValue) ?? defaultMassUnit
        guard let row = defaultUnits.firstIndex(of: massUnit) else { return }
        massUnitPicker.selectRow(row, inComponent: 0, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSUbiquitousKeyValueStore.default.synchronize()
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
