// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import CoreData

struct LiftData {
    var date: Date
    var reps: Int16
    var weight: Double
    var oneRM: Double
    var rating: Int16
    var notes: String
    var exercise: Exercise
    var unit: Unit

    init(from lift: Lift) {
        self.date = lift.date
        self.reps = lift.reps
        self.weight = lift.weight
        self.oneRM = lift.oneRM
        self.rating = lift.rating
        self.notes = lift.notes
        self.exercise = lift.exercise
        self.unit = lift.unit
    }

    init(date: Date, reps: Int16, weight: Double, oneRM: Double, rating: Int16, notes: String, exercise: Exercise, unit: Unit) {
        self.date = date
        self.reps = reps
        self.weight = weight
        self.oneRM = oneRM
        self.rating = rating
        self.notes = notes
        self.exercise = exercise
        self.unit = unit
    }

}

@objc(Lift)
class Lift: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged var reps: Int16
    @NSManaged var weight: Double
    @NSManaged var oneRM: Double
    @NSManaged var rating: Int16
    @NSManaged var notes: String
    @NSManaged var exercise: Exercise
    @NSManaged var unit: Unit
}
