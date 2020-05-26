// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import CoreData

struct ExerciseData {
    var name: String
    var order: Int16
    var ofLift: Set<Lift>?
}

class Exercise: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var order: Int16
    @NSManaged public var ofLift: Set<Lift>?
}
