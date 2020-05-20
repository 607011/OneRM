import Cocoa

import "../Exercise"
import "../Defaults"

var str = "Hello, playground"



let exercises = DefaultExercises.enumerated().map { ExerciseData(name: $0.1, order: Int16($0.0)) }
try! LiftDataManager.shared.save(exercises: exercises)

print("ready.")
