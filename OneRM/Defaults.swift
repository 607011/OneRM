// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation

let defaultUnits: [String] = [
    "kg",
    "lbs"
]
let defaultMassUnit: String = Locale.current.usesMetricSystem
    ? "kg"
    : "lbs"
let defaultBarWeight: Double = Locale.current.usesMetricSystem
    ? 20
    : 44.0
let defaultPlates: [Double] = Locale.current.usesMetricSystem
    ? [50, 25, 20, 15, 10, 5, 2.5, 2, 1.5, 1.25, 0.5]
    : [110.23, 55.12, 44.09, 33.07, 22.05, 11.02, 5.51, 4.41, 3.31, 2.2, 1.1]

let defaultPlateColors: [String] = [
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

let massUnitKey = "massUnit"
let barWeightKey = "barWeight"
let weightKey = "weight"
let repsKey = "reps"
let platesKey = "plates"
let maxPercentKey = "maxPercent"
let minPercentKey = "minPercent"
let percentStepKey = "percentStep"
let exercisesKey = "exercises"
let lastSavedExerciseKey = "lastSavedExercise"
let lastSaveDateKey = "lastSaveDate"
let lastSaveRatingKey = "lastSaveRating"
let lastSaveNotesKey = "lastSaveNotes"
let formulasKey = "formulas"
