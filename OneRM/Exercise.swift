/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import CoreData

class Exercise: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var order: Int16
}


extension Exercise {
    @objc(addExerciseObject:)
    @NSManaged public func addToExercises(_ value: Exercise)

    @objc(removeExerciseObject:)
    @NSManaged public func removeFromExercises(_ value: Exercise)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ value: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ value: NSSet)
}
