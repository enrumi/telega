import UIKit

// MARK: - Экран контактов (упрощённая версия)
class ContactsViewController: UIViewController {
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Contacts"
        label.font = TelegramFonts.chatListTitle
        label.textColor = TelegramTheme.ChatList.titleColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = TelegramTheme.ChatList.backgroundColor
        title = "Contacts"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = TelegramTheme.NavigationBar.opaqueBackgroundColor
        navigationController?.navigationBar.tintColor = TelegramTheme.NavigationBar.buttonColor
        
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
