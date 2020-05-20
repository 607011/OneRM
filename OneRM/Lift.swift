/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

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
