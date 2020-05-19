/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class PercentageLimitsViewController: UITableViewController {

    @IBOutlet weak var maxPercentField: UITextField!
    @IBOutlet weak var minPercentField: UITextField!
    @IBOutlet weak var percentStepField: UITextField!


    private var maxPercent: Int = DefaultMaxPercent {
        didSet {
            UserDefaults.standard.set(maxPercent, forKey: MaxPercentKey)
        }
    }

    private var minPercent: Int = DefaultMinPercent {
        didSet {
            UserDefaults.standard.set(minPercent, forKey: MinPercentKey)
        }
    }

    private var percentStep: Int = DefaultPercentStep {
        didSet {
            UserDefaults.standard.set(percentStep, forKey: PercentStepKey)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        maxPercentField.delegate = self
        minPercentField.delegate = self
        percentStepField.delegate = self
        if UserDefaults.standard.object(forKey: MaxPercentKey) != nil {
            maxPercent = UserDefaults.standard.integer(forKey: MaxPercentKey)
        }
        if UserDefaults.standard.object(forKey: MinPercentKey) != nil {
            minPercent = UserDefaults.standard.integer(forKey: MinPercentKey)
        }
        if UserDefaults.standard.object(forKey: PercentStepKey) != nil {
            percentStep = UserDefaults.standard.integer(forKey: PercentStepKey)
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardDidShow(notification:)),
            name: UITextField.textDidChangeNotification,
            object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        maxPercentField.text = "\(UserDefaults.standard.integer(forKey: MaxPercentKey))"
        minPercentField.text = "\(UserDefaults.standard.integer(forKey: MinPercentKey))"
        percentStepField.text = "\(UserDefaults.standard.integer(forKey: PercentStepKey))"
    }

    @objc func keyboardDidShow(notification: Notification) -> Void {
        guard notification.name == UITextField.textDidChangeNotification else { return }
        guard let field = notification.object as? UITextField else { return }
        switch field {
            case maxPercentField:
                maxPercent = Int(maxPercentField.text ?? "") ?? DefaultMaxPercent
            case minPercentField:
                minPercent = Int(minPercentField.text ?? "") ?? DefaultMinPercent
            case percentStepField:
                percentStep = Int(percentStepField.text ?? "") ?? DefaultPercentStep
            default: break
        }
    }
}


extension PercentageLimitsViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case maxPercentField: fallthrough
        case minPercentField: fallthrough
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
