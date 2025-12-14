import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Создаём главное окно
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        // Проверяем авторизацию
        if NetworkManager.shared.isAuthorized() {
            print("✅ Пользователь авторизован, показываем главный экран")
            showMainInterface()
        } else {
            print("⚠️ Пользователь не авторизован, показываем авторизацию")
            showAuthorizationInterface()
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - Navigation
    
    func showAuthorizationInterface() {
        let authController = AuthorizationPhoneViewController_New()
        // onAuthSuccess handled in AuthorizationCodeViewController_New
            self?.showMainInterface()
        }
        
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
