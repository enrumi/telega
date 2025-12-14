import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
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
    }
    
    // MARK: - Navigation
    
    func showAuthorizationInterface() {
        let authController = AuthorizationPhoneViewController()
        authController.onAuthSuccess = { [weak self] in
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
}
