import UIKit
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
struct TelegramTheme {
    static let accentColor = UIColor(rgb: 0x007aff)
    struct NavigationBar {
        static let disabledButtonColor = UIColor(rgb: 0xd0d0d0)
        static let primaryTextColor = UIColor(rgb: 0x000000)
        static let secondaryTextColor = UIColor(rgb: 0x787878)
        static let controlColor = UIColor(rgb: 0x7e8791)
        static let accentTextColor = accentColor
        static let blurredBackgroundColor = UIColor(rgb: 0xf2f2f2, alpha: 0.9)
        static let opaqueBackgroundColor = UIColor(rgb: 0xf7f7f7)  // mixedWith .white, alpha: 0.14
        static let separatorColor = UIColor(rgb: 0xc8c7cc)
        static let badgeBackgroundColor = UIColor(rgb: 0xff3b30)
        static let badgeStrokeColor = UIColor(rgb: 0xff3b30)
        static let badgeTextColor = UIColor(rgb: 0xffffff)
        static let segmentedBackgroundColor = UIColor(rgb: 0x000000, alpha: 0.06)
        static let segmentedForegroundColor = UIColor(rgb: 0xf7f7f7)
        static let segmentedTextColor = UIColor(rgb: 0x000000)
        static let segmentedDividerColor = UIColor(rgb: 0xd6d6dc)
        static let clearButtonBackgroundColor = UIColor(rgb: 0xE3E3E3, alpha: 0.78)
        static let clearButtonForegroundColor = UIColor(rgb: 0x7f7f7f)
    }
    struct TabBar {
        static let separatorColor = UIColor(rgb: 0xb2b2b2)
        static let iconColor = UIColor(rgb: 0x959595)
        static let selectedIconColor = accentColor
        static let textColor = UIColor(rgb: 0x959595)
        static let selectedTextColor = accentColor
        static let badgeBackgroundColor = UIColor(rgb: 0xff3b30)
        static let badgeStrokeColor = UIColor(rgb: 0xff3b30)
        static let badgeTextColor = UIColor(rgb: 0xffffff)
    }
    struct ChatList {
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
    struct Chat {
        static let backgroundColor = UIColor(rgb: 0xffffff)
        static let serviceBackgroundColor = UIColor(rgb: 0x000000, alpha: 0.2)
        static let serviceTextColor = UIColor(rgb: 0xffffff)
    }
    struct Authorization {
        static let backgroundColor = UIColor(rgb: 0xffffff)
        static let inputFieldBackgroundColor = UIColor(rgb: 0xf2f2f7)
        static let inputFieldStrokeColor = UIColor(rgb: 0xf2f2f7)
        static let inputFieldPlaceholderColor = UIColor(rgb: 0xb6b6bb)
        static let inputFieldPrimaryColor = UIColor(rgb: 0x000000)
        static let inputFieldControlColor = UIColor(rgb: 0xb6b6bb)
    }
    struct SearchBar {
        static let accentColor = TelegramTheme.accentColor
        static let inputFillColor = UIColor(rgb: 0x000000, alpha: 0.06)
        static let inputTextColor = UIColor(rgb: 0x000000)
        static let inputPlaceholderTextColor = UIColor(rgb: 0x8e8e93)
        static let inputIconColor = UIColor(rgb: 0x8e8e93)
        static let inputClearButtonColor = UIColor(rgb: 0x7b7b81)
        static let separatorColor = UIColor(rgb: 0xc8c7cc)
    }
    struct Settings {
    }
    // MARK: - Common
    struct Common {
        static let separatorColor = UIColor(rgb: 0xc8c7cc)
        static let destructiveColor = UIColor(rgb: 0xff3b30)
        static let successColor = UIColor(rgb: 0x35c759)
        static let warningColor = UIColor(rgb: 0xff9500)
    }
}
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

