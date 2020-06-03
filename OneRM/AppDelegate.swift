// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

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
        registerAppSettings()
        let kvStore = NSUbiquitousKeyValueStore.default
        kvStore.synchronize()
//        if kvStore.object(forKey: Key.barWeight.rawValue) == nil {
//            kvStore.set(defaultBarWeight, forKey: Key.barWeight.rawValue)
//        }
//        if kvStore.object(forKey: Key.plates.rawValue) == nil {
//            kvStore.set(defaultPlates, forKey: Key.plates.rawValue)
//        }
        if kvStore.object(forKey: Key.maxPercent.rawValue) == nil {
            kvStore.set(defaultMaxPercent, forKey: Key.maxPercent.rawValue)
        }
        if kvStore.object(forKey: Key.minPercent.rawValue) == nil {
            kvStore.set(defaultMinPercent, forKey: Key.minPercent.rawValue)
        }
        if kvStore.object(forKey: Key.percentStep.rawValue) == nil {
            kvStore.set(defaultPercentStep, forKey: Key.percentStep.rawValue)
        }
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(iCloudAvailabilityChanged),
//                                               name: Notification.Name.NSUbiquityIdentityDidChange,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(externalStorageChanged),
//                                               name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
//                                               object: nil)

        UINavigationBar.appearance().backgroundColor = UIColor(named: "Olive")
        UINavigationBar.appearance().barTintColor = UIColor(named: "Olive")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        return true
    }

//    @objc func externalStorageChanged(notification: Notification) {
//        debugPrint("externalStorageChanged()")
//    }
//
//    @objc func iCloudAvailabilityChanged(notification: Notification) {
//        debugPrint("iCloudAvailabilityChanged()")
//        let kvStore = NSUbiquitousKeyValueStore.default
//        if let idToken = FileManager.default.ubiquityIdentityToken,
//            let newTokenData = try? NSKeyedArchiver.archivedData(withRootObject: idToken, requiringSecureCoding: false) {
//            if let oldTokenData = kvStore.object(forKey: "net.ersatzworld.OneRM.UbiquityIdentityToken") as? Data {
//                if oldTokenData != newTokenData {
//                    // user has changed identity -> clear local caches of exercises, lifts units and settings
//                }
//            }
//            kvStore.set(newTokenData, forKey: "net.ersatzworld.OneRM.UbiquityIdentityToken")
//        } else {
//            // user has logged out of iCloud
//            kvStore.removeObject(forKey: "net.ersatzworld.OneRM.UbiquityIdentityToken")
//        }
//    }

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
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
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
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description?.setOption(true as NSNumber, forKey: "NSPersistentStoreRemoteChangeNotificationOptionKey")
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
