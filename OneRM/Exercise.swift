/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import CoreData

struct ExerciseData {
    var name: String
    var order: Int16
}

class Exercise: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var order: Int16
    @NSManaged public var ofLift: Set<Lift>?
}

//extension Exercise {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
//        return NSFetchRequest<Exercise>(entityName: "Exercise")
//    }
//}
//
//
//extension Exercise {
//    @objc(addExerciseObject:)
//    @NSManaged public func addToExercises(_ value: Exercise)
//
//    @objc(removeExerciseObject:)
//    @NSManaged public func removeFromExercises(_ value: Exercise)
//
//    @objc(addExercises:)
//    @NSManaged public func addToExercises(_ value: NSSet)
//
//    @objc(removeExercises:)
//    @NSManaged public func removeFromExercises(_ value: NSSet)
//}
