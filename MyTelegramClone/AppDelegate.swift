import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        if NetworkManager.shared.isAuthorized() {
            showMainInterface()
        } else {
            showAuthorizationInterface()
        }
        window?.makeKeyAndVisible()
        return true
    }
    // MARK: - Navigation
    func showAuthorizationInterface() {
        let authController = AuthorizationPhoneViewController_New()
        let navigationController = UINavigationController(rootViewController: authController)
        navigationController.navigationBar.prefersLargeTitles = false
        window?.rootViewController = navigationController
    }
    func showMainInterface() {
        let mainTabBarController = MainTabBarController()
        window?.rootViewController = mainTabBarController
    }
    // MARK: - UISceneSession Lifecycle (iOS 13+)
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
