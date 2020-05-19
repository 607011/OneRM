/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import CoreData
import UIKit

class LiftDataManager {
    static let shared = LiftDataManager()
    private init() {}
    private lazy var persistentContainer: NSPersistentContainer = {
        debugPrint("LiftDataManager.persistentContainer")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            debugPrint("AppDelegate not present")
            let container = NSPersistentContainer(name: "OneRM")
            container.loadPersistentStores(completionHandler: { _, error in
                _ = error.map { fatalError("Unresolved error \($0)") }
            })
            return container
        }
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

    func loadUnits() -> [Unit] {
        let mainContext = LiftDataManager.shared.mainContext
        do {
            var units = try mainContext.fetch(LiftDataManager.unitFetchRequest())
            units.sort(by: { $0.name < $1.name })
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
            var exercises = try mainContext.fetch(LiftDataManager.exerciseFetchRequest())
            exercises.sort(by: { $0.order < $1.order })
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
            var lifts = try mainContext.fetch(LiftDataManager.liftFetchRequest())
            lifts.sort(by: { $0.date > $1.date })
            return lifts
        }
        catch {
            debugPrint(error)
        }
        return []
    }

    func saveLift(weight: Double, reps: Int, exercise: Exercise) throws {
        let context = LiftDataManager.shared.backgroundContext()
        context.perform {
            let entity = Lift.entity()
            let lift = Lift(entity: entity, insertInto: context)
            lift.weight = weight
            lift.reps = Int16(reps)
            lift.date = Date()
            lift.mutableSetValue(forKey: "exercise").add(exercise)
            try! context.save()
        }
    }

    func save() throws -> Void {
        try backgroundContext().save()
    }

    func save(exercise: Exercise) throws -> Void {
        let ctx = LiftDataManager.shared.backgroundContext()
        ctx.perform {
            exercise.addToExercises(exercise)
        }
    }

    func save(exercise: ExerciseData) throws -> Void {
        debugPrint("save(exercise: \(exercise.name))")
        let ctx = LiftDataManager.shared.backgroundContext()
        ctx.perform {
            let ex = Exercise(entity: Exercise.entity(), insertInto: ctx)
            ex.name = exercise.name
            ex.order = exercise.order
            try! ctx.save()
        }
    }

    func save(exercises: [Exercise]) throws -> Void {
        for exercise in exercises {
            try save(exercise: exercise)
        }
    }

    func save(exercises: [ExerciseData]) throws -> Void {
        for exercise in exercises {
            try save(exercise: exercise)
        }
    }

    func save(lifts: [Lift]) throws -> Void {
        debugPrint("save(lifts:)")
    }

    func save(units: [Unit]) throws -> Void {
        debugPrint("save(units:)")
    }

    func replace(exercise: Exercise, with: Exercise) -> Void {
        debugPrint("replace(exercise:with:)")
    }
}
