/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class MainViewController: UIViewController {

    private typealias MVC = MainViewController

    static let WeightDigitCount: Int = 5
    static let WeightData: [[Int]] = [[Int]](repeating: Array(0...9), count: MVC.WeightDigitCount)
    static let RepData: [Int] = Array(1...12)
    static let DefaultRepsInView: Int = 12

    @IBOutlet weak var weightPicker: UIPickerView!
    @IBOutlet weak var repsPicker: UIPickerView!
    @IBOutlet weak var repsCollectionView: UICollectionView!

    var repsInView: Int = DefaultRepsInView
    var massUnit: String = DefaultMassUnit
    let repsInViewReuseId: String = "repsCell"

    var reps: Int = 1 {
        didSet {
            repsCollectionView.reloadData()
            UserDefaults.standard.set(reps, forKey: RepsKey)
        }
    }
    var weight: Double = 0 {
        didSet {
            repsCollectionView.reloadData()
            UserDefaults.standard.set(weight, forKey: WeightKey)
        }
    }

    var oneRM: Double {
        get {
            return brzycki(weight: weight, reps: reps)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        weightPicker.delegate = self
        weightPicker.dataSource = self
        repsPicker.delegate = self
        repsPicker.dataSource = self
        repsCollectionView.delegate = self
        repsCollectionView.dataSource = self
        weight = UserDefaults.standard.double(forKey: WeightKey)
        var w = weight
        var divisor = pow(10.0, Double(MVC.WeightDigitCount - 2))
        for idx in 0..<MVC.WeightDigitCount {
            let v = Int(w / divisor)
            w -= Double(v) * divisor
            guard let row = MVC.WeightData[idx].firstIndex(of: v) else { continue }
            weightPicker.selectRow(row, inComponent: idx, animated: false)
            divisor /= 10
        }
        reps = min(UserDefaults.standard.integer(forKey: RepsKey), MVC.RepData.last!)
        guard let row = MVC.RepData.firstIndex(of: reps) else { return }
        repsPicker.selectRow(row, inComponent: 0, animated: false)
        if let layout = repsCollectionView?.collectionViewLayout as? RMCollectionLayout {
            layout.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        massUnit = UserDefaults.standard.string(forKey: MassUnitKey) ?? DefaultMassUnit
        repsCollectionView.reloadData()
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
            let destination = segue.destination as! SaveToLogViewController
            destination.reps = reps
            destination.weight = weight
            destination.oneRM = oneRM
            destination.massUnit = massUnit
        }
    }
}

extension MainViewController {
    func nextLower(weight: Double) -> (Double, [String]) {
        var plates: [Double] = DefaultPlates
        let bar: Double = DefaultBarWeight
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

extension MainViewController: RMCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeAtIndexPath indexPath: IndexPath) -> CGSize {
        let itemSize = (repsCollectionView.frame.width - (repsCollectionView.contentInset.left + repsCollectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 95)
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
                NSAttributedString.Key.foregroundColor: UIColor.white,
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: repsInViewReuseId, for: indexPath as IndexPath) as! RepCollectionViewCell
        let reps = indexPath.item + 1
        cell.repLabel.text = "\(reps)RM"
        cell.unitLabel.text = massUnit
        let orm = brzycki(weight: self.weight, reps: self.reps)
        let nrm = brzycki_rev(maxWeight: orm, reps: reps)
        cell.weightLabel.text = String(format: "%.1f", nrm)
        cell.percentLabel.text = orm.isAlmostNull()
            ? ""
            : String(format: "%g%% 1RM", (1e2 * nrm / orm).rounded(toPlaces: 1))
        return cell
    }
}
