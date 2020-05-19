/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var massUnitLabel: UILabel!
    @IBOutlet weak var limitsLabel: UILabel!
    @IBOutlet weak var buildDateLabel: UILabel!

    var buildDate: Date {
        if let infoPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath),
            let infoDate = infoAttr[.modificationDate] as? Date
        {
            return infoDate
        }
        return Date()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        versionLabel.text = "\(version) (\(build))"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        buildDateLabel.text = "\(dateFormatter.string(from: buildDate))"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let massUnit = UserDefaults.standard.string(forKey: MassUnitKey)
        massUnitLabel.text = "\(massUnit ?? DefaultMassUnit)"
        let maxPercent = UserDefaults.standard.integer(forKey: MaxPercentKey)
        let minPercent = UserDefaults.standard.integer(forKey: MinPercentKey)
        let percentStep = UserDefaults.standard.integer(forKey: PercentStepKey)
        limitsLabel.text = "\(minPercent)…\(maxPercent) +\(percentStep)"
    }
}
