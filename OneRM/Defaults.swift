// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation

let defaultMassUnit: String = Locale.current.usesMetricSystem
    ? "kg"
    : "lbs"

//let defaultBarWeight: Double = Locale.current.usesMetricSystem
//    ? 20
//    : 44.0

//let defaultPlates: [Double] = Locale.current.usesMetricSystem
//    ? [50, 25, 20, 15, 10, 5, 2.5, 2, 1.5, 1.25, 0.5]
//    : [110.23, 55.12, 44.09, 33.07, 22.05, 11.02, 5.51, 4.41, 3.31, 2.2, 1.1]

//let defaultPlateColors: [String] = [
//    NSLocalizedString("black", comment: ""),
//    NSLocalizedString("red", comment: ""),
//    NSLocalizedString("blue", comment: ""),
//    NSLocalizedString("yellow", comment: ""),
//    NSLocalizedString("green", comment: ""),
//    NSLocalizedString("white", comment: ""),
//    NSLocalizedString("red", comment: ""),
//    NSLocalizedString("blue", comment: ""),
//    NSLocalizedString("yellow", comment: ""),
//    NSLocalizedString("green", comment: ""),
//    NSLocalizedString("white", comment: "")
//]

let defaultExercises: [String] = [
    "Bench press",
    "Deadlift",
    "Squat",
    "Front squat",
    "Overhead squat",
    "Front press",
    "Push press",
    "Power clean",
    "Snatch",
    "Clean & jerk"
]

let defaultMaxPercent = 120
let defaultMinPercent = 10
let defaultPercentStep = 5

enum Key: String {
    case massUnit
    case barWeight
    case weight
    case reps
    case plates
    case maxPercent
    case minPercent
    case percentStep
    case exercises
    case lastSavedExercise
    case lastSaveDate
    case lastSaveRating
    case lastSaveNotes
    case formulaBrzycki
    case formulaEpley
    case formulaLombardi
    case formulaMayhew
    case formulaMcGlothin
    case formulaOConner
    case formulaWathen
}

func registerAppSettings() {
    guard let settingsUrl = Bundle.main.url(forResource: "Settings", withExtension: "bundle"),
        let settingsData = try? Data(contentsOf: settingsUrl.appendingPathComponent("Root.plist")),
        let settingsPlist = try? PropertyListSerialization.propertyList(
            from: settingsData,
            options: [],
            format: nil) as? [String: Any],
        let settingsPreferences = settingsPlist["PreferenceSpecifiers"] as? [[String: Any]] else {
            return }
    let currentUnits = LiftDataManager.shared.loadUnits()
    var newUnits: [UnitData] = []
    debugPrint("currentUnits = \(currentUnits.map({ $0.name }))")
    var defaultsToRegister: [String: Any] = [:]
    settingsPreferences.forEach { preference in
        if let key = preference["Key"] as? String {
            defaultsToRegister[key] = preference["DefaultValue"]
            if key == "massUnit",
                let values = preference["Values"] as? [String] {
                for unitName in values {
                    if !currentUnits.contains(where: { $0.name == unitName }) {
                        newUnits.append(UnitData(name: unitName))
                    }
                }
            }
        }
    }
    debugPrint("newUnits = \(newUnits)")
    if !newUnits.isEmpty {
        LiftDataManager.shared.save(units: newUnits)
    }
    UserDefaults.standard.register(defaults: defaultsToRegister)
}
