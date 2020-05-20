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

//extension Unit {
//    @objc(addUnitObject:)
//    @NSManaged public func addToUnits(_ value: Unit)
//
//    @objc(removeUnitObject:)
//    @NSManaged public func removeFromUnits(_ value: Unit)
//
//    @objc(addUnits:)
//    @NSManaged public func addToUnits(_ value: NSSet)
//
//    @objc(removeUnits:)
//    @NSManaged public func removeFromUnits(_ value: NSSet)
//}
