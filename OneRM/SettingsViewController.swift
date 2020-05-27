// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

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
            let infoDate = infoAttr[.modificationDate] as? Date {
            return infoDate
        }
        return Date()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        buildDateLabel.text = "\(dateFormatter.string(from: buildDate))"
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String  else { return }
        guard let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { return }
        versionLabel.text = "\(version) (\(build))"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let massUnit = UserDefaults.standard.string(forKey: Key.massUnit.rawValue)
        massUnitLabel.text = "\(massUnit ?? defaultMassUnit)"
        let maxPercent = UserDefaults.standard.integer(forKey: Key.maxPercent.rawValue)
        let minPercent = UserDefaults.standard.integer(forKey: Key.minPercent.rawValue)
        let percentStep = UserDefaults.standard.integer(forKey: Key.percentStep.rawValue)
        limitsLabel.text = "\(minPercent)…\(maxPercent) +\(percentStep)"
    }
}
