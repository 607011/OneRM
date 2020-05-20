/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import CoreData

struct LiftData {
    var date: Date = Date()
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

//extension Lift {
//    @objc(addLiftObject:)
//    @NSManaged public func addToLifts(_ value: Lift)
//
//    @objc(removeLiftObject:)
//    @NSManaged public func removeFromLifts(_ value: Lift)
//
//    @objc(addLifts:)
//    @NSManaged public func addToLifts(_ value: NSSet)
//
//    @objc(removeLifts:)
//    @NSManaged public func removeFromLifts(_ value: NSSet)
//}
