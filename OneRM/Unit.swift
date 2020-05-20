/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import CoreData

struct UnitData {
    var name: String
}

@objc(Unit)
class Unit: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var ofLift: Set<Lift>?
}
