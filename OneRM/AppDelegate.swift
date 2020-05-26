/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit
import CoreData
import Foundation

enum AppError: Error {
    case initialized
    case notInitialized
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.object(forKey: BarWeightKey) == nil {
            UserDefaults.standard.set(DefaultBarWeight, forKey: BarWeightKey)
        }
        if UserDefaults.standard.object(forKey: MassUnitKey) == nil {
            UserDefaults.standard.set(DefaultMassUnit, forKey: MassUnitKey)
        }
        if UserDefaults.standard.object(forKey: PlatesKey) == nil {
            UserDefaults.standard.set(DefaultPlates, forKey: PlatesKey)
        }
        if UserDefaults.standard.object(forKey: MaxPercentKey) == nil {
            UserDefaults.standard.set(DefaultMaxPercent, forKey: MaxPercentKey)
        }
        if UserDefaults.standard.object(forKey: MinPercentKey) == nil {
            UserDefaults.standard.set(DefaultMinPercent, forKey: MinPercentKey)
        }
        if UserDefaults.standard.object(forKey: PercentStepKey) == nil {
            UserDefaults.standard.set(DefaultPercentStep, forKey: PercentStepKey)
        }
        if UserDefaults.standard.object(forKey: FormulasKey) == nil {
            UserDefaults.standard.set([Formula.brzycki.rawValue], forKey: FormulasKey)
        }


        // UserDefaults.standard.set(false, forKey: "appSuccessfullyInitialized")
        if isFirstStart() {
            addDefaultEntities(completeFirstLaunch)
        }

        UINavigationBar.appearance().backgroundColor = UIColor(named: "Olive")
        UINavigationBar.appearance().barTintColor = UIColor(named: "Olive")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "OneRM")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension AppDelegate {

    func isFirstStart() -> Bool {
        return !UserDefaults.standard.bool(forKey: "appSuccessfullyInitialized")
    }

    func completeFirstLaunch(_ error: AppError) -> Void {
        if error == .initialized {
            UserDefaults.standard.set(true, forKey: "appSuccessfullyInitialized")
        }
        else {
            debugPrint("ERROR: 1st launch not successfully completed")
        }
    }

    func addDefaultEntities(_ completionHandler: (_ error: AppError) -> Void) -> Void {

        let exercises = DefaultExercises.enumerated().map { ExerciseData(name: $0.1, order: Int16($0.0)) }
        try! LiftDataManager.shared.save(exercises: exercises)

        let units = DefaultUnits.map { UnitData(name: $0) }
        try! LiftDataManager.shared.save(units: units)

        completionHandler(.initialized)
    }
}
