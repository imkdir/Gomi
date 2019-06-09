import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [
            MainTableViewController(),
            ReminderListViewController(),
            GuideCollectionViewController()
        ].map(UINavigationController.init(rootViewController:))
        
        window.rootViewController = tabBarController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

