// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit
import SideMenu

class MainViewController: UIViewController {

    @IBOutlet private weak var weightPicker: UIPickerView!
    @IBOutlet private weak var repsPicker: UIPickerView!
    @IBOutlet private weak var repsCollectionView: UICollectionView!

    private let repInterval: ClosedRange = 1...12
    private var repData: [Int] = []
    private var weightData: [[Int]] = [[]]
    private var massUnit: String = defaultMassUnit
    private var formula: OneRMFormula = Brzycki()
    private lazy var factors: [Double] = {
        var factors = Array(repeating: 0.0, count: weightPicker.numberOfComponents)
        var factor = pow(10.0, Double(weightPicker.numberOfComponents - 1))
        for idx in 0..<weightPicker.numberOfComponents {
            factor *= 0.1
            factors[idx] = factor
        }
        return factors
    }()

    private var cellWidth: CGFloat = 130

    private var reps: Int = 1 {
        didSet {
            repsCollectionView.reloadData()
            NSUbiquitousKeyValueStore.default.set(reps, forKey: Key.reps.rawValue)
        }
    }

    private var weight: Double = 0 {
        didSet {
            repsCollectionView.reloadData()
            NSUbiquitousKeyValueStore.default.set(weight, forKey: Key.weight.rawValue)
        }
    }

    private var oneRM: Double {
        return formula.oneRM(weight: weight, reps: Int(reps))
    }

    private func updateWeightPicker(from weight: Double) {
        var w = weight
        for idx in 0..<weightPicker.numberOfComponents {
            let divisor = factors[idx]
            let v = Int(w / divisor)
            w -= Double(v) * divisor
            if let row = weightData[idx].firstIndex(of: v) {
                weightPicker.selectRow(row, inComponent: idx, animated: false)
            }
        }
    }

    private func updateRepsPicker(from reps: Int) {
        if let row = repData.firstIndex(of: Int(reps)) {
            repsPicker.selectRow(row, inComponent: 0, animated: false)
        }
    }

    @objc func updateFromDefaults(notification: Notification) {
        guard let defaults = notification.object as? UserDefaults else { return }
        massUnit = defaults.string(forKey: Key.massUnit.rawValue) ?? defaultMassUnit
        formula = currentFormula()
        repsCollectionView.reloadData()
    }

    fileprivate func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController =
            storyboard?.instantiateViewController(withIdentifier: "SideMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFromDefaults), name: UserDefaults.didChangeNotification, object: nil)
        setupSideMenu()
        weightPicker.delegate = self
        weightPicker.dataSource = self
        weightData = [[Int]](repeating: Array(0...9), count: weightPicker.numberOfComponents)
        repsPicker.delegate = self
        repsPicker.dataSource = self
        repData = Array(repInterval)
        repsCollectionView.delegate = self
        repsCollectionView.dataSource = self
        if let layout = repsCollectionView?.collectionViewLayout as? RepCollectionViewCellLayout {
            layout.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // cellWidth must be recalculated on every appearance because massUnit could have changed
        let attributedString = NSAttributedString(string: "8888.8 \(massUnit)",
            attributes: [.font: UIFont.systemFont(ofSize: 25.0, weight: .semibold)])
        cellWidth = ceil(attributedString.size().width)
        massUnit = UserDefaults.standard.string(forKey: Key.massUnit.rawValue) ?? defaultMassUnit
        formula = currentFormula()
        weight = NSUbiquitousKeyValueStore.default.double(forKey: Key.weight.rawValue)
        updateWeightPicker(from: weight)
        reps = repInterval.clamp(value: Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.reps.rawValue)))
        updateRepsPicker(from: reps)
        repsCollectionView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSUbiquitousKeyValueStore.default.synchronize()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        repsCollectionView?.collectionViewLayout.invalidateLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        repsCollectionView?.collectionViewLayout.invalidateLayout()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveToLog" {
            guard let destination = segue.destination as? SaveToLogViewController else { return }
            destination.reps = reps
            destination.weight = weight
            destination.oneRM = oneRM
            destination.massUnit = massUnit
        }
    }
}

//extension MainViewController {
//    func nextLower(weight: Double) -> (Double, [String]) {
//        var plates: [Double] = defaultPlates
//        let bar: Double = defaultBarWeight
//        if weight < bar {
//            return (0, [])
//        }
//        var result: [String] = ["\(bar) \(massUnit)"]
//        var x = bar
//        while x < weight && plates.first != nil {
//            while 2 * plates.first! <= weight - x {
//                x += 2 * plates.first!
//                result.append("2 × \(plates.first!) \(massUnit)")
//            }
//            plates.removeFirst()
//        }
//        return (x, result)
//    }
//}

extension MainViewController: RepsCollectionViewCellLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeAtIndexPath indexPath: IndexPath) -> CGSize {
        let itemSize = cellWidth
        return CGSize(width: itemSize, height: 80)
    }
}

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case weightPicker: return 10
        case repsPicker: return repData.count
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case weightPicker:
            var w = 0.0
            for idx in 0..<weightPicker.numberOfComponents {
                let v = weightData[component][weightPicker.selectedRow(inComponent: idx)]
                w += Double(v) * factors[idx]
            }
            weight = w
        case repsPicker:
            reps = repData[row]
        default: break
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case weightPicker: return "\(weightData[component][row])"
        case repsPicker: return "\(repData[row])"
        default: return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch pickerView {
        case weightPicker: return 32
        case repsPicker: return 32
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString?
        if pickerView == weightPicker && component == 4 {
            attributedString = NSAttributedString(string: String(weightData[component][row]), attributes: [
                NSAttributedString.Key.backgroundColor: UIColor.gray,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ])
        }
        return attributedString
    }
}

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case weightPicker: return 5
        case repsPicker: return 1
        default: return 0
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "repsCell", for: indexPath as IndexPath) as? RepCollectionViewCell {
            let reps = indexPath.item + 1
            cell.repLabel.text = "\(reps)RM"
            let orm = formula.oneRM(weight: self.weight, reps: Int(self.reps))
            let nrm = formula.rm(for: reps, with: orm)
            cell.weightLabel.text = "\(String(format: "%.1f", nrm)) \(massUnit)"
            cell.percentLabel.text = orm.isAlmostNull()
                ? ""
                : String(format: "%g%% 1RM", (1e2 * nrm / orm).rounded(toPlaces: 1))
            return cell
        }
        return UICollectionViewCell()
    }
}
