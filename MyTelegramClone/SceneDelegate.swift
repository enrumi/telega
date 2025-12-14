import UIKit
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        if NetworkManager.shared.isAuthorized() {
            showMainInterface()
        } else {
            showAuthorizationInterface()
        }
        window?.makeKeyAndVisible()
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
}
