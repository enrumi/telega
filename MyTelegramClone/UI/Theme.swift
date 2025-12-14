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
    
    // MARK: - Chat List (ТОЧНЫЕ цвета из DefaultDayPresentationTheme.swift)
    struct ChatList {
        static let backgroundColor = UIColor(rgb: 0xffffff)
        static let itemSeparatorColor = UIColor(rgb: 0xc8c7cc)
        static let itemBackgroundColor = UIColor(rgb: 0xffffff)
        static let pinnedItemBackgroundColor = UIColor(rgb: 0xf7f7f7)
        static let itemHighlightedBackgroundColor = UIColor(rgb: 0xe5e5ea)
        static let pinnedItemHighlightedBackgroundColor = UIColor(rgb: 0xe5e5ea)
        static let itemSelectedBackgroundColor = UIColor(rgb: 0xe9f0fa)
        
        static let titleColor = UIColor(rgb: 0x000000)
        static let secretTitleColor = UIColor(rgb: 0x00b12c)
        static let dateTextColor = UIColor(rgb: 0x8e8e93)
        static let authorNameColor = UIColor(rgb: 0x000000)
        static let messageTextColor = UIColor(rgb: 0x8e8e93)
        static let messageHighlightedTextColor = UIColor(rgb: 0x000000)
        static let messageDraftTextColor = UIColor(rgb: 0xdd4b39)
        
        static let checkmarkColor = accentColor
        static let pendingIndicatorColor = UIColor(rgb: 0x8e8e93)
        static let failedFillColor = UIColor(rgb: 0xff3b30)
        static let failedForegroundColor = UIColor(rgb: 0xffffff)
        
        static let muteIconColor = UIColor(rgb: 0xa7a7ad)
        static let unreadBadgeActiveBackgroundColor = accentColor
        static let unreadBadgeActiveTextColor = UIColor(rgb: 0xffffff)
        static let unreadBadgeInactiveBackgroundColor = UIColor(rgb: 0xb6b6bb)
        static let unreadBadgeInactiveTextColor = UIColor(rgb: 0xffffff)
        
        static let reactionBadgeActiveBackgroundColor = UIColor(rgb: 0xff2d55)
        static let pinnedBadgeColor = UIColor(rgb: 0xb6b6bb)
        static let pinnedSearchBarColor = UIColor(rgb: 0xe5e5e5)
        static let regularSearchBarColor = UIColor(rgb: 0xe9e9e9)
        
        static let sectionHeaderFillColor = UIColor(rgb: 0xf7f7f7)
        static let sectionHeaderTextColor = UIColor(rgb: 0x8e8e93)
        
        static let verifiedIconFillColor = accentColor
        static let verifiedIconForegroundColor = UIColor(rgb: 0xffffff)
        static let secretIconColor = UIColor(rgb: 0x00b12c)
        
        static let onlineDotColor = UIColor(rgb: 0x4cc91f)
    }
    
    // MARK: - Chat (Messages) - ТОЧНЫЕ цвета из оригинала
    struct Chat {
        static let backgroundColor = UIColor(rgb: 0xffffff)
        
        // Входящие сообщения (белые пузыри)
        static let incomingBubbleBackgroundColor = UIColor(rgb: 0xffffff)
        static let incomingBubbleHighlightedBackgroundColor = UIColor(rgb: 0xd9f4ff)
        static let incomingBubblePrimaryTextColor = UIColor(rgb: 0x000000)
        static let incomingBubbleSecondaryTextColor = UIColor(rgb: 0x525252, alpha: 0.6)
        static let incomingBubbleLinkTextColor = UIColor(rgb: 0x004bad)
        static let incomingBubbleAccentTextColor = accentColor
        
        // Исходящие сообщения (зелёные пузыри)
        static let outgoingBubbleBackgroundColor = UIColor(rgb: 0xe1ffc7)
        static let outgoingBubbleHighlightedBackgroundColor = UIColor(rgb: 0xbaff93)
        static let outgoingBubblePrimaryTextColor = UIColor(rgb: 0x000000)
        static let outgoingBubbleSecondaryTextColor = UIColor(rgb: 0x008c09, alpha: 0.8)
        static let outgoingBubbleLinkTextColor = UIColor(rgb: 0x00731f)
        static let outgoingBubbleAccentTextColor = UIColor(rgb: 0x00a700)
        
        // Поле ввода
        static let inputBackgroundColor = UIColor(rgb: 0xffffff)
        static let inputFieldBackgroundColor = UIColor(rgb: 0xf2f2f7)
        static let inputFieldTextColor = UIColor(rgb: 0x000000)
        static let inputFieldPlaceholderColor = UIColor(rgb: 0xb6b6bb)
        static let inputPanelSeparatorColor = UIColor(rgb: 0xc8c7cc)
        static let inputPanelBackgroundColor = UIColor(rgb: 0xf7f7f7)
        
        // Кнопки
        static let sendButtonColor = accentColor
        static let sendButtonDisabledColor = UIColor(rgb: 0x7e7e87)
        static let mediaButtonColor = UIColor(rgb: 0x7e7e87)
        
        // Service messages (дата, системные сообщения)
        static let serviceBackgroundColor = UIColor(rgb: 0x000000, alpha: 0.2)
        static let serviceTextColor = UIColor(rgb: 0xffffff)
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
