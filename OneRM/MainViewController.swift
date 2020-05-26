/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit
import CloudKit

class MainViewController: UIViewController {

    private typealias MVC = MainViewController

    static let WeightDigitCount: Int = 5
    static let WeightData: [[Int]] = [[Int]](repeating: Array(0...9), count: MVC.WeightDigitCount)
    static let RepInterval: ClosedRange = 1...12
    static let RepData: [Int] = Array(RepInterval)
    static let DefaultRepsInView: Int = 12

    @IBOutlet private weak var weightPicker: UIPickerView!
    @IBOutlet private weak var repsPicker: UIPickerView!
    @IBOutlet private weak var repsCollectionView: UICollectionView!

    private var repsInView: Int = DefaultRepsInView
    private var massUnit: String = defaultMassUnit
    private var formula: OneRMFormula = Brzycki()

    private var cellWidth: CGFloat = 130

    private var reps: Int = 1 {
        didSet {
            repsCollectionView.reloadData()
            UserDefaults.standard.set(reps, forKey: repsKey)
        }
    }
    private var weight: Double = 0 {
        didSet {
            repsCollectionView.reloadData()
            UserDefaults.standard.set(weight, forKey: weightKey)
        }
    }

    private var oneRM: Double {
        return formula.oneRM(weight: weight, reps: reps)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        weightPicker.delegate = self
        weightPicker.dataSource = self
        repsPicker.delegate = self
        repsPicker.dataSource = self
        repsCollectionView.delegate = self
        repsCollectionView.dataSource = self
        weight = UserDefaults.standard.double(forKey: weightKey)
        var w = weight
        var divisor = pow(10.0, Double(MVC.WeightDigitCount - 2))
        for idx in 0..<MVC.WeightDigitCount {
            let v = Int(w / divisor)
            w -= Double(v) * divisor
            guard let row = MVC.WeightData[idx].firstIndex(of: v) else { continue }
            weightPicker.selectRow(row, inComponent: idx, animated: false)
            divisor /= 10
        }
        reps = MVC.RepInterval.clamp(value: UserDefaults.standard.integer(forKey: repsKey))
        if let row = MVC.RepData.firstIndex(of: reps) {
            repsPicker.selectRow(row, inComponent: 0, animated: false)
        }
        if let layout = repsCollectionView?.collectionViewLayout as? RepCollectionViewCellLayout {
            layout.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        massUnit = UserDefaults.standard.string(forKey: massUnitKey) ?? defaultMassUnit

        /// cellWidth must be recalculated on every appearance because massUnit could have changed
        let attributedString = NSAttributedString(string: "8888.8 \(massUnit)",
            attributes: [.font: UIFont.systemFont(ofSize: 25.0, weight: .semibold)])
        cellWidth = ceil(attributedString.size().width)

        repsCollectionView.reloadData()
        if UserDefaults.standard.object(forKey: formulasKey) != nil {
            guard let activeFormulas = UserDefaults.standard.object(forKey: formulasKey) as? [String] else { return }
            formula = activeFormulas.isEmpty
                ? Brzycki()
                : MixedOneRM(formulas: activeFormulas)
        }
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

extension MainViewController {
    func nextLower(weight: Double) -> (Double, [String]) {
        var plates: [Double] = defaultPlates
        let bar: Double = defaultBarWeight
        if weight < bar {
            return (0, [])
        }
        var result: [String] = ["\(bar) \(massUnit)"]
        var x = bar
        while x < weight && plates.first != nil {
            while 2 * plates.first! <= weight - x {
                x += 2 * plates.first!
                result.append("2 × \(plates.first!) \(massUnit)")
            }
            plates.removeFirst()
        }
        return (x, result)
    }
}

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
        case repsPicker: return MVC.RepData.count
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case weightPicker:
            var w = 0.0
            var factor = pow(10.0, Double(MVC.WeightDigitCount - 2))
            for idx in 0..<MVC.WeightDigitCount {
                let v = MVC.WeightData[component][weightPicker.selectedRow(inComponent: idx)]
                w += Double(v) * factor
                factor /= 10
            }
            weight = w
        case repsPicker:
            reps = MVC.RepData[row]
        default: break
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case weightPicker: return "\(MVC.WeightData[component][row])"
        case repsPicker: return "\(MVC.RepData[row])"
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
            attributedString = NSAttributedString(string: String(MVC.WeightData[component][row]), attributes: [
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
        case weightPicker: return MVC.WeightDigitCount
        case repsPicker: return 1
        default: return 0
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repsInView
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "repsCell", for: indexPath as IndexPath) as? RepCollectionViewCell {
            let reps = indexPath.item + 1
            cell.repLabel.text = "\(reps)RM"
            let orm = formula.oneRM(weight: self.weight, reps: self.reps)
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
