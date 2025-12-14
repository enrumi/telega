import UIKit

// MARK: - Главный TabBar (1:1 с Telegram)
class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        // Применяем тему Telegram
        tabBar.backgroundColor = TelegramTheme.TabBar.backgroundColor
        tabBar.tintColor = TelegramTheme.TabBar.selectedIconColor
        tabBar.unselectedItemTintColor = TelegramTheme.TabBar.iconColor
        tabBar.isTranslucent = true
        
        // Линия сверху
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = TelegramTheme.TabBar.separatorColor.cgColor
    }
    
    private func setupViewControllers() {
        // 1. Чаты
        let chatsViewController = ChatListViewController()
        let chatsNavController = UINavigationController(rootViewController: chatsViewController)
        chatsNavController.tabBarItem = UITabBarItem(
            title: "Chats",
            image: UIImage(systemName: "message"),
            selectedImage: UIImage(systemName: "message.fill")
        )
        
        // 2. Контакты
        let contactsViewController = ContactsViewController()
        let contactsNavController = UINavigationController(rootViewController: contactsViewController)
        contactsNavController.tabBarItem = UITabBarItem(
            title: "Contacts",
            image: UIImage(systemName: "person.2"),
            selectedImage: UIImage(systemName: "person.2.fill")
        )
        
        // 3. Настройки (v2.0 с профилем и username)
        let settingsViewController = SettingsViewController_New()
        let settingsNavController = UINavigationController(rootViewController: settingsViewController)
        settingsNavController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        viewControllers = [
            chatsNavController,
            contactsNavController,
            settingsNavController
        ]
    }
}
