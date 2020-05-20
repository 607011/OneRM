/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation

let DefaultUnits: [String] = [
    "kg",
    "lbs"
]
let DefaultMassUnit: String = Locale.current.usesMetricSystem
    ? "kg"
    : "lbs"
let DefaultBarWeight: Double = Locale.current.usesMetricSystem
    ? 20
    : 44.0
let DefaultPlates: [Double] = Locale.current.usesMetricSystem
    ? [50, 25, 20, 15, 10, 5, 2.5, 2, 1.5, 1.25, 0.5]
    : [110.23, 55.12, 44.09, 33.07, 22.05, 11.02, 5.51, 4.41, 3.31, 2.2, 1.1]

let DefaultPlateColors: [String] = [
    NSLocalizedString("black", comment: ""),
    NSLocalizedString("red", comment: ""),
    NSLocalizedString("blue", comment: ""),
    NSLocalizedString("yellow", comment: ""),
    NSLocalizedString("green", comment: ""),
    NSLocalizedString("white", comment: ""),
    NSLocalizedString("red", comment: ""),
    NSLocalizedString("blue", comment: ""),
    NSLocalizedString("yellow", comment: ""),
    NSLocalizedString("green", comment: ""),
    NSLocalizedString("white", comment: "")
]

let DefaultExercises: [String] = [
    "Bench press",
    "Deadlift",
    "Squat",
    "Front squat",
    "Overhead squat",
    "Front press",
    "Push press",
    "Power clean",
    "Snatch",
    "Clean & jerk",
]

let DefaultMaxPercent = 120
let DefaultMinPercent = 10
let DefaultPercentStep = 5

let MassUnitKey = "massUnit"
let BarWeightKey = "barWeight"
let WeightKey = "weight"
let RepsKey = "reps"
let PlatesKey = "plates"
let MaxPercentKey = "maxPercent"
let MinPercentKey = "minPercent"
let PercentStepKey = "percentStep"
let ExercisesKey = "exercises"
