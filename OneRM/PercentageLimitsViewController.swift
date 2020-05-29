// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class PercentageLimitsViewController: UITableViewController {

    @IBOutlet weak var maxPercentField: UITextField!
    @IBOutlet weak var minPercentField: UITextField!
    @IBOutlet weak var percentStepField: UITextField!

    private var maxPercent: Int = defaultMaxPercent {
        didSet {
            NSUbiquitousKeyValueStore.default.set(maxPercent, forKey: Key.maxPercent.rawValue)
        }
    }

    private var minPercent: Int = defaultMinPercent {
        didSet {
            NSUbiquitousKeyValueStore.default.set(minPercent, forKey: Key.minPercent.rawValue)
        }
    }

    private var percentStep: Int = defaultPercentStep {
        didSet {
            NSUbiquitousKeyValueStore.default.set(percentStep, forKey: Key.percentStep.rawValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        maxPercentField.delegate = self
        minPercentField.delegate = self
        percentStepField.delegate = self
        if NSUbiquitousKeyValueStore.default.object(forKey: Key.maxPercent.rawValue) != nil {
            maxPercent = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.maxPercent.rawValue))
        }
        if NSUbiquitousKeyValueStore.default.object(forKey: Key.minPercent.rawValue) != nil {
            minPercent = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.minPercent.rawValue))
        }
        if NSUbiquitousKeyValueStore.default.object(forKey: Key.percentStep.rawValue) != nil {
            percentStep = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.percentStep.rawValue))
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardDidShow(notification:)),
            name: UITextField.textDidChangeNotification,
            object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        maxPercentField.text = "\(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.maxPercent.rawValue))"
        minPercentField.text = "\(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.minPercent.rawValue))"
        percentStepField.text = "\(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.percentStep.rawValue))"
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSUbiquitousKeyValueStore.default.synchronize()
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
