// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class PercentageLimitsViewController: UITableViewController {

    @IBOutlet weak var maxPercentField: UITextField!
    @IBOutlet weak var minPercentField: UITextField!
    @IBOutlet weak var percentStepField: UITextField!

    private var maxPercent: Int = defaultMaxPercent {
        didSet {
            UserDefaults.standard.set(maxPercent, forKey: Key.maxPercent.rawValue)
        }
    }

    private var minPercent: Int = defaultMinPercent {
        didSet {
            UserDefaults.standard.set(minPercent, forKey: Key.minPercent.rawValue)
        }
    }

    private var percentStep: Int = defaultPercentStep {
        didSet {
            UserDefaults.standard.set(percentStep, forKey: Key.percentStep.rawValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        maxPercentField.delegate = self
        minPercentField.delegate = self
        percentStepField.delegate = self
        if UserDefaults.standard.object(forKey: Key.maxPercent.rawValue) != nil {
            maxPercent = UserDefaults.standard.integer(forKey: Key.maxPercent.rawValue)
        }
        if UserDefaults.standard.object(forKey: Key.minPercent.rawValue) != nil {
            minPercent = UserDefaults.standard.integer(forKey: Key.minPercent.rawValue)
        }
        if UserDefaults.standard.object(forKey: Key.percentStep.rawValue) != nil {
            percentStep = UserDefaults.standard.integer(forKey: Key.percentStep.rawValue)
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardDidShow(notification:)),
            name: UITextField.textDidChangeNotification,
            object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        maxPercentField.text = "\(UserDefaults.standard.integer(forKey: Key.maxPercent.rawValue))"
        minPercentField.text = "\(UserDefaults.standard.integer(forKey: Key.minPercent.rawValue))"
        percentStepField.text = "\(UserDefaults.standard.integer(forKey: Key.percentStep.rawValue))"
    }

    @objc func keyboardDidShow(notification: Notification) {
        guard notification.name == UITextField.textDidChangeNotification else { return }
        guard let field = notification.object as? UITextField else { return }
        switch field {
        case maxPercentField:
            maxPercent = Int(maxPercentField.text ?? "") ?? defaultMaxPercent
        case minPercentField:
            minPercent = Int(minPercentField.text ?? "") ?? defaultMinPercent
        case percentStepField:
            percentStep = Int(percentStepField.text ?? "") ?? defaultPercentStep
        default: break
        }
    }
}

extension PercentageLimitsViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case maxPercentField: fallthrough // swiftlint:disable:this no_fallthrough_only
        case minPercentField: fallthrough // swiftlint:disable:this no_fallthrough_only
        case percentStepField:
            let characterSet = CharacterSet(charactersIn: string)
            return CharacterSet.decimalDigits.isSuperset(of: characterSet)
        default: return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case maxPercentField: maxPercent = Int(maxPercentField.text!)!
        case minPercentField: minPercent = Int(minPercentField.text!)!
        case percentStepField: percentStep = Int(percentStepField.text!)!
        default: break
        }
    }

}
