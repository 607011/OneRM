/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import CoreData

class Lift: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged var reps: Int16
    @NSManaged var weight: Double
}

extension Lift {
    @objc(addLiftObject:)
    @NSManaged public func addToLifts(_ value: Lift)

    @objc(removeLiftObject:)
    @NSManaged public func removeFromLifts(_ value: Lift)

    @objc(addLifts:)
    @NSManaged public func addToLifts(_ value: NSSet)

    @objc(removeLifts:)
    @NSManaged public func removeFromLifts(_ value: NSSet)
}
