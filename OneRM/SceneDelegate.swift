import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let logSplitViewController = tabBarController.viewControllers?.last as? UISplitViewController,
            let leftNavController = logSplitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.viewControllers.first as? LogViewController,
            let detailNavController = logSplitViewController.viewControllers.last as? UINavigationController,
            let detailViewController = detailNavController.topViewController as? LogDetailViewController else {
                return
        }
        masterViewController.delegate = detailViewController
        detailViewController.lift = masterViewController.lifts.first
        detailViewController.navigationItem.leftItemsSupplementBackButton = true
        detailViewController.navigationItem.leftBarButtonItem = logSplitViewController.displayModeButtonItem
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
