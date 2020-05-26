// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import CoreData

struct UnitData {
    var name: String
    var ofLift: Set<Lift>?
}

@objc(Unit)
class Unit: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var ofLift: Set<Lift>?
}
