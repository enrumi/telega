import UIKit

// MARK: - UIColor Extension (из оригинала Telegram)
extension UIColor {
    convenience init(rgb: UInt32, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xff) / 255.0,
            green: CGFloat((rgb >> 8) & 0xff) / 255.0,
            blue: CGFloat(rgb & 0xff) / 255.0,
            alpha: alpha
        )
    }
}

// MARK: - Telegram Theme (точные цвета из оригинала)
struct TelegramTheme {
    
    // MARK: - Акцентный цвет
    static let accentColor = UIColor(rgb: 0x007aff)
    
    // MARK: - Navigation Bar
    struct NavigationBar {
        static let backgroundColor = UIColor(rgb: 0xf7f7f7)
        static let blurredBackground = UIColor(rgb: 0xf2f2f2, alpha: 0.9)
        static let separatorColor = UIColor(rgb: 0xc8c7cc)
        static let titleColor = UIColor(rgb: 0x000000)
        static let buttonColor = accentColor
        static let disabledButtonColor = UIColor(rgb: 0xd0d0d0)
    }
    
    // MARK: - Tab Bar
    struct TabBar {
        static let backgroundColor = UIColor(rgb: 0xf2f2f2, alpha: 0.9)
        static let separatorColor = UIColor(rgb: 0xb2b2b2)
        static let iconColor = UIColor(rgb: 0x959595)
        static let selectedIconColor = accentColor
        static let textColor = UIColor(rgb: 0x959595)
        static let selectedTextColor = accentColor
        static let badgeBackgroundColor = UIColor(rgb: 0xff3b30)
        static let badgeTextColor = UIColor(rgb: 0xffffff)
    }
    
    // MARK: - Chat List
    struct ChatList {
        static let backgroundColor = UIColor(rgb: 0xffffff)
        static let itemBackgroundColor = UIColor(rgb: 0xffffff)
        static let itemHighlightedBackgroundColor = UIColor(rgb: 0xe5e5ea)
        static let itemSeparatorColor = UIColor(rgb: 0xc8c7cc)
        
        static let titleColor = UIColor(rgb: 0x000000)
        static let messageColor = UIColor(rgb: 0x8e8e93)
        static let dateColor = UIColor(rgb: 0x8e8e93)
        
        static let unreadBadgeBackgroundColor = UIColor(rgb: 0x007aff)
        static let unreadBadgeTextColor = UIColor(rgb: 0xffffff)
        
        static let mutedBadgeBackgroundColor = UIColor(rgb: 0xd0d0d5)
        static let mutedBadgeTextColor = UIColor(rgb: 0xffffff)
    }
    
    // MARK: - Chat (Messages)
    struct Chat {
        static let backgroundColor = UIColor(rgb: 0xffffff)
        
        // Входящие сообщения
        static let incomingBubbleBackgroundColor = UIColor(rgb: 0xf1f1f4)
        static let incomingBubbleTextColor = UIColor(rgb: 0x000000)
        static let incomingBubbleSecondaryTextColor = UIColor(rgb: 0x8e8e93)
        
        // Исходящие сообщения
        static let outgoingBubbleBackgroundColor = UIColor(rgb: 0xd4f4dd)
        static let outgoingBubbleTextColor = UIColor(rgb: 0x000000)
        static let outgoingBubbleSecondaryTextColor = UIColor(rgb: 0x6fa86f)
        
        // Поле ввода
        static let inputBackgroundColor = UIColor(rgb: 0xffffff)
        static let inputFieldBackgroundColor = UIColor(rgb: 0xf2f2f7)
        static let inputFieldTextColor = UIColor(rgb: 0x000000)
        static let inputFieldPlaceholderColor = UIColor(rgb: 0xb6b6bb)
        static let inputPanelSeparatorColor = UIColor(rgb: 0xc8c7cc)
        
        // Кнопка отправки
        static let sendButtonColor = accentColor
        static let sendButtonDisabledColor = UIColor(rgb: 0xd0d0d0)
    }
    
    // MARK: - Authorization
    struct Authorization {
        static let backgroundColor = UIColor(rgb: 0xffffff)
        static let primaryTextColor = UIColor(rgb: 0x000000)
        static let secondaryTextColor = UIColor(rgb: 0x8e8e93)
        static let accentColor = TelegramTheme.accentColor
        
        // Кнопка "Next"
        static let buttonBackgroundColor = accentColor
        static let buttonTextColor = UIColor(rgb: 0xffffff)
        static let buttonDisabledBackgroundColor = UIColor(rgb: 0xe5e5ea)
        static let buttonDisabledTextColor = UIColor(rgb: 0x8e8e93)
        
        // Поле ввода
        static let inputFieldBackgroundColor = UIColor(rgb: 0xf2f2f7)
        static let inputFieldTextColor = UIColor(rgb: 0x000000)
        static let inputFieldPlaceholderColor = UIColor(rgb: 0xb6b6bb)
    }
    
    // MARK: - Search Bar
    struct SearchBar {
        static let backgroundColor = UIColor(rgb: 0xffffff)
        static let inputFillColor = UIColor(rgb: 0x000000, alpha: 0.06)
        static let inputTextColor = UIColor(rgb: 0x000000)
        static let inputPlaceholderColor = UIColor(rgb: 0x8e8e93)
        static let inputIconColor = UIColor(rgb: 0x8e8e93)
        static let cancelButtonColor = accentColor
    }
    
    // MARK: - Settings
    struct Settings {
        static let backgroundColor = UIColor(rgb: 0xefeff4)
        static let itemBackgroundColor = UIColor(rgb: 0xffffff)
        static let itemTitleColor = UIColor(rgb: 0x000000)
        static let itemValueColor = UIColor(rgb: 0x8e8e93)
        static let itemSeparatorColor = UIColor(rgb: 0xc8c7cc)
        static let sectionHeaderColor = UIColor(rgb: 0x6d6d72)
        static let destructiveColor = UIColor(rgb: 0xff3b30)
    }
    
    // MARK: - Common
    struct Common {
        static let separatorColor = UIColor(rgb: 0xc8c7cc)
        static let destructiveColor = UIColor(rgb: 0xff3b30)
        static let successColor = UIColor(rgb: 0x35c759)
        static let warningColor = UIColor(rgb: 0xff9500)
    }
}

// MARK: - Fonts (Telegram использует системный шрифт)
struct TelegramFonts {
    // Navigation
    static let navigationTitle = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let navigationButton = UIFont.systemFont(ofSize: 17, weight: .regular)
    
    // Chat List
    static let chatListTitle = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let chatListMessage = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let chatListDate = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let chatListBadge = UIFont.systemFont(ofSize: 14, weight: .medium)
    
    // Chat
    static let messageText = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let messageTime = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let messageName = UIFont.systemFont(ofSize: 15, weight: .semibold)
    
    // Input
    static let inputText = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let inputPlaceholder = UIFont.systemFont(ofSize: 17, weight: .regular)
    
    // Authorization
    static let authTitle = UIFont.systemFont(ofSize: 28, weight: .bold)
    static let authDescription = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let authInput = UIFont.systemFont(ofSize: 20, weight: .regular)
    static let authButton = UIFont.systemFont(ofSize: 17, weight: .semibold)
    
    // Tab Bar
    static let tabBarText = UIFont.systemFont(ofSize: 10, weight: .regular)
    
    // Settings
    static let settingsItemTitle = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let settingsItemValue = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let settingsSectionHeader = UIFont.systemFont(ofSize: 13, weight: .regular)
}
