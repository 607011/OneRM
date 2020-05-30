// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var massUnitLabel: UILabel!
    @IBOutlet weak var limitsLabel: UILabel!
    @IBOutlet weak var buildDateLabel: UILabel!
    @IBOutlet weak var syncWithiCloudCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        if let infoPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath),
            let buildDate = infoAttr[.modificationDate] as? Date {
            buildDateLabel.text = "\(dateFormatter.string(from: buildDate))"
        }
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            versionLabel.text = "\(version) (\(build))"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let massUnit = UserDefaults.standard.string(forKey: Key.massUnit.rawValue)
        massUnitLabel.text = "\(massUnit ?? defaultMassUnit)"
        let maxPercent = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.maxPercent.rawValue))
        let minPercent = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.minPercent.rawValue))
        let percentStep = Int(NSUbiquitousKeyValueStore.default.longLong(forKey: Key.percentStep.rawValue))
        limitsLabel.text = "\(minPercent)…\(maxPercent) +\(percentStep)"
        syncWithiCloudCell.accessoryType = FileManager.default.ubiquityIdentityToken == nil
            ? .none
            : .checkmark
    }

}
