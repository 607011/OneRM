/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import CoreData

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
