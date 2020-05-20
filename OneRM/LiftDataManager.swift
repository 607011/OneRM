/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import CoreData
import UIKit

class LiftDataManager {
    static let shared = LiftDataManager()
    private init() {}
    lazy var appDelegate: AppDelegate? = {
        return UIApplication.shared.delegate as? AppDelegate
    }()
    lazy var persistentContainer: NSPersistentContainer = {
        guard let appDelegate = self.appDelegate else {
            debugPrint("WARNING: Could not access AppDelegate. Falling back to NSPersistentContainer.")
            let container = NSPersistentContainer(name: "OneRM")
            container.loadPersistentStores(completionHandler: { _, error in
                _ = error.map { fatalError("Unresolved error \($0)") }
            })
            return container
        }
        appDelegate.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return appDelegate.persistentContainer
    }()

    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    @nonobjc public class func exerciseFetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @nonobjc public class func liftFetchRequest() -> NSFetchRequest<Lift> {
        return NSFetchRequest<Lift>(entityName: "Lift")
    }

    @nonobjc public class func unitFetchRequest() -> NSFetchRequest<Unit> {
        return NSFetchRequest<Unit>(entityName: "Unit")
    }

    func save() -> Void {
        appDelegate?.saveContext()
    }

    func loadUnits() -> [Unit] {
        let mainContext = LiftDataManager.shared.mainContext
        do {
            let fetchRequest = LiftDataManager.unitFetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            let units = try mainContext.fetch(fetchRequest)
            return units
        }
        catch {
            debugPrint(error)
        }
        return []
    }

    func loadExercises() -> [Exercise] {
        let mainContext = LiftDataManager.shared.mainContext
        do {
            let fetchRequest = LiftDataManager.exerciseFetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
            let exercises = try mainContext.fetch(fetchRequest)
            return exercises
        }
        catch {
            debugPrint(error)
        }
        return []
    }

    func loadLifts() -> [Lift] {
        let mainContext = LiftDataManager.shared.mainContext
        do {
            let fetchRequest = LiftDataManager.liftFetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            let lifts = try mainContext.fetch(fetchRequest)
            return lifts
        }
        catch {
            debugPrint(error)
        }
        return []
    }

    func load(unitWithName name: String) -> Unit? {
        let fetchRequest = LiftDataManager.unitFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        guard let units = try? LiftDataManager.shared.mainContext.fetch(fetchRequest),
            units.count == 1
            else { return nil }
        return units[0]
    }

    func save(exercises: [ExerciseData]) throws -> Void {
        let ctx = LiftDataManager.shared.backgroundContext()
        ctx.perform {
            for exercise in exercises {
                let ex = Exercise(entity: Exercise.entity(), insertInto: ctx)
                ex.name = exercise.name
                ex.order = exercise.order
            }
            try! ctx.save()
        }
    }

    func save(units: [UnitData]) throws -> Void {
        let ctx = LiftDataManager.shared.backgroundContext()
        ctx.perform {
            for unit in units {
                let u = Unit(entity: Unit.entity(), insertInto: ctx)
                u.name = unit.name
            }
            try! ctx.save()
        }
    }

    func save(lift: LiftData) throws -> Void {
        let newLift = Lift(entity: Lift.entity(), insertInto: mainContext)
        newLift.reps = lift.reps
        newLift.weight = lift.weight
        newLift.rating = lift.rating
        newLift.date = Date()
        newLift.oneRM = lift.oneRM
        newLift.exercise = lift.exercise
        newLift.unit = lift.unit
        newLift.notes = lift.notes
        newLift.exercise.ofLift?.update(with: newLift)
        newLift.unit.ofLift?.update(with: newLift)
        save()
    }

    func save(exercise: ExerciseData) throws -> Void {
        let newExercise = Exercise(entity: Exercise.entity(), insertInto: mainContext)
        newExercise.name = exercise.name
        newExercise.order = exercise.order
        newExercise.ofLift = exercise.ofLift
        save()
    }
}
