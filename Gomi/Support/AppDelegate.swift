import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Composition Root
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        
        let store = Store(path: "table")!
        let searchHistory = SearchHistory(userDefaults: .standard)
        
        tabBarController.viewControllers = [
            MainTableViewController(store: store, searchHistory: searchHistory),
            ReminderListViewController(userDefaults: .standard)
        ].map(UINavigationController.init(rootViewController:))
        
        window.rootViewController = tabBarController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

