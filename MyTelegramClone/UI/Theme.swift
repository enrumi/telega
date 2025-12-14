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
    
    // MARK: - Navigation Bar (из DefaultDayPresentationTheme.swift, строки 412-431)
    struct NavigationBar {
        static let buttonColor = accentColor  // Строка 413
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
    
    // MARK: - Tab Bar (из DefaultDayPresentationTheme.swift, строки 433-443)
    struct TabBar {
        static let backgroundColor = UIColor(rgb: 0xf2f2f2, alpha: 0.9)  // Строка 434
        static let separatorColor = UIColor(rgb: 0xb2b2b2)
        static let iconColor = UIColor(rgb: 0x959595)
        static let selectedIconColor = accentColor
        static let textColor = UIColor(rgb: 0x959595)
        static let selectedTextColor = accentColor
        static let badgeBackgroundColor = UIColor(rgb: 0xff3b30)
        static let badgeStrokeColor = UIColor(rgb: 0xff3b30)
        static let badgeTextColor = UIColor(rgb: 0xffffff)
    }
    
    // MARK: - Chat List (из DefaultDayPresentationTheme.swift, строки 539-578)
    struct ChatList {
        static let backgroundColor = UIColor(rgb: 0xffffff)  // Строка 540
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
        
        static let reactionBadgeActiveBackgroundColor = UIColor(rgb: 0xFF2D55)  // Строка 563
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
    
    // MARK: - Chat (Messages) - из DefaultDayPresentationTheme.swift, строки 587-748
    struct Chat {
        static let backgroundColor = UIColor(rgb: 0xffffff)
        
        // Входящие сообщения (белые пузыри) - строки 588-642
        static let incomingBubbleBackgroundColor = UIColor(rgb: 0xffffff)  // Строка 591
        static let incomingBubbleHighlightedBackgroundColor = UIColor(rgb: 0xd9f4ff)  // Строка 592
        static let incomingBubblePrimaryTextColor = UIColor(rgb: 0x000000)  // Строка 623
        static let incomingBubbleSecondaryTextColor = UIColor(rgb: 0x525252, alpha: 0.6)  // Строка 624
        static let incomingBubbleLinkTextColor = UIColor(rgb: 0x004bad)  // Строка 625
        static let incomingBubbleAccentTextColor = accentColor  // Строка 629
        static let incomingBubbleScamColor = UIColor(rgb: 0xff3b30)  // Строка 627
        static let incomingBubbleTextHighlightColor = UIColor(rgb: 0xffe438)  // Строка 628
        static let incomingBubbleFileTitleColor = UIColor(rgb: 0x0b8bed)  // Строка 636
        static let incomingBubbleFileDescriptionColor = UIColor(rgb: 0x999999)  // Строка 637
        static let incomingBubbleMediaPlaceholderColor = UIColor(rgb: 0xe8ecf0)  // Строка 639
        
        // Исходящие сообщения (зелёные пузыри) - строки 643-700
        static let outgoingBubbleBackgroundColor = UIColor(rgb: 0xe1ffc7)  // Строка 646
        static let outgoingBubbleHighlightedBackgroundColor = UIColor(rgb: 0xbaff93)  // Строка 647
        static let outgoingBubblePrimaryTextColor = UIColor(rgb: 0x000000)  // Строка 678
        static let outgoingBubbleSecondaryTextColor = UIColor(rgb: 0x008c09, alpha: 0.8)  // Строка 679
        static let outgoingBubbleLinkTextColor = UIColor(rgb: 0x004bad)  // Строка 680
        static let outgoingBubbleAccentTextColor = UIColor(rgb: 0x00a700)  // Строка 684
        static let outgoingBubbleScamColor = UIColor(rgb: 0xff3b30)  // Строка 682
        static let outgoingBubbleTextHighlightColor = UIColor(rgb: 0xffe438)  // Строка 683
        static let outgoingBubbleFileTitleColor = UIColor(rgb: 0x3faa3c)  // Строка 691
        static let outgoingBubbleFileDescriptionColor = UIColor(rgb: 0x6fb26a)  // Строка 692
        static let outgoingBubbleMediaPlaceholderColor = UIColor(rgb: 0xd2f2b6)  // Строка 694
        
        // Общие цвета сообщений - строки 735-748
        static let infoPrimaryTextColor = UIColor(rgb: 0x000000)  // Строка 735
        static let infoLinkTextColor = UIColor(rgb: 0x004bad)  // Строка 736
        static let outgoingCheckColor = UIColor(rgb: 0x19c700)  // Строка 737
        static let mediaDateAndStatusFillColor = UIColor(white: 0.0, alpha: 0.3)  // Строка 738
        static let mediaDateAndStatusTextColor = UIColor(rgb: 0xffffff)  // Строка 739
        
        // Поле ввода - из inputPanel (строки 940-959)
        static let panelBackgroundColor = UIColor(rgb: 0xf2f2f2, alpha: 0.9)  // Строка 941 (blurredBackgroundColor)
        static let panelBackgroundColorNoWallpaper = UIColor(rgb: 0xffffff)  // Строка 942
        static let panelSeparatorColor = UIColor(rgb: 0xb2b2b2)  // Строка 943
        static let panelControlAccentColor = accentColor  // Строка 944
        static let panelControlColor = UIColor(rgb: 0x858e99)  // Строка 945
        static let panelControlDisabledColor = UIColor(rgb: 0x727b87, alpha: 0.5)  // Строка 946
        static let panelControlDestructiveColor = UIColor(rgb: 0xff3b30)  // Строка 947
        static let inputBackgroundColor = UIColor(rgb: 0xffffff)  // Строка 948
        static let inputStrokeColor = UIColor(rgb: 0x000000, alpha: 0.1)  // Строка 949
        static let inputPlaceholderColor = UIColor(rgb: 0xbebec0)  // Строка 950
        static let inputTextColor = UIColor(rgb: 0x000000)  // Строка 951
        static let inputControlColor = UIColor(rgb: 0x868D98)  // Строка 952
        static let actionControlFillColor = accentColor  // Строка 953
        static let actionControlForegroundColor = UIColor(rgb: 0xffffff)  // Строка 954
        static let primaryTextColor = UIColor(rgb: 0x000000)  // Строка 955
        static let secondaryTextColor = UIColor(rgb: 0x8e8e93)  // Строка 956
        static let mediaRecordingDotColor = UIColor(rgb: 0xed2521)  // Строка 957
        
        // Service messages (дата, системные сообщения)
        static let serviceBackgroundColor = UIColor(rgb: 0x000000, alpha: 0.2)
        static let serviceTextColor = UIColor(rgb: 0xffffff)
    }
    
    // MARK: - Authorization (из PresentationThemeIntro, строки 398-405)
    struct Authorization {
        static let backgroundColor = UIColor(rgb: 0xffffff)
        static let primaryTextColor = UIColor(rgb: 0x000000)  // Строка 400
        static let accentTextColor = accentColor  // Строка 401
        static let disabledTextColor = UIColor(rgb: 0xd0d0d0)  // Строка 402
        static let startButtonColor = UIColor(rgb: 0x2ca5e0)  // Строка 403
        static let dotColor = UIColor(rgb: 0xd9d9d9)  // Строка 404
        
        // Поле ввода (из list.itemInputField, строка 530)
        static let inputFieldBackgroundColor = UIColor(rgb: 0xf2f2f7)
        static let inputFieldStrokeColor = UIColor(rgb: 0xf2f2f7)
        static let inputFieldPlaceholderColor = UIColor(rgb: 0xb6b6bb)
        static let inputFieldPrimaryColor = UIColor(rgb: 0x000000)
        static let inputFieldControlColor = UIColor(rgb: 0xb6b6bb)
    }
    
    // MARK: - Search Bar (из DefaultDayPresentationTheme.swift, строки 445-454)
    struct SearchBar {
        static let backgroundColor = UIColor(rgb: 0xffffff)  // Строка 446
        static let accentColor = TelegramTheme.accentColor
        static let inputFillColor = UIColor(rgb: 0x000000, alpha: 0.06)
        static let inputTextColor = UIColor(rgb: 0x000000)
        static let inputPlaceholderTextColor = UIColor(rgb: 0x8e8e93)
        static let inputIconColor = UIColor(rgb: 0x8e8e93)
        static let inputClearButtonColor = UIColor(rgb: 0x7b7b81)
        static let separatorColor = UIColor(rgb: 0xc8c7cc)
    }
    
    // MARK: - Settings (из PresentationThemeList, строки 472-537)
    struct Settings {
        static let blocksBackgroundColor = UIColor(rgb: 0xefeff4)  // Строка 473
        static let plainBackgroundColor = UIColor(rgb: 0xffffff)  // Строка 475
        static let itemPrimaryTextColor = UIColor(rgb: 0x000000)  // Строка 477
        static let itemSecondaryTextColor = UIColor(rgb: 0x8e8e93)  // Строка 478
        static let itemDisabledTextColor = UIColor(rgb: 0x8e8e93)  // Строка 479
        static let itemAccentColor = accentColor  // Строка 480
        static let itemHighlightedColor = UIColor(rgb: 0x00b12c)  // Строка 481
        static let itemDestructiveColor = UIColor(rgb: 0xff3b30)  // Строка 482
        static let itemPlaceholderTextColor = UIColor(rgb: 0xc8c8ce)  // Строка 483
        static let itemBlocksBackgroundColor = UIColor(rgb: 0xffffff)  // Строка 484
        static let itemHighlightedBackgroundColor = UIColor(rgb: 0xe5e5ea)  // Строка 486
        static let itemBlocksSeparatorColor = UIColor(rgb: 0xc8c7cc)  // Строка 487
        static let itemPlainSeparatorColor = UIColor(rgb: 0xc8c7cc)  // Строка 488
        static let disclosureArrowColor = UIColor(rgb: 0xbab9be)  // Строка 489
        static let sectionHeaderTextColor = UIColor(rgb: 0x6d6d72)  // Строка 490
        static let freeTextColor = UIColor(rgb: 0x6d6d72)  // Строка 491
        static let freeTextErrorColor = UIColor(rgb: 0xcf3030)  // Строка 492
        static let freeTextSuccessColor = UIColor(rgb: 0x26972c)  // Строка 493
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
