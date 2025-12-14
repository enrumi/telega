import Foundation
import UIKit
public struct PresentationTheme {
    public let list: PresentationThemeList
    public let chatList: PresentationThemeChatList
    public init(list: PresentationThemeList, chatList: PresentationThemeChatList) {
        self.list = list
        self.chatList = chatList
    }
    public static var `default`: PresentationTheme {
        return PresentationTheme(
            list: PresentationThemeList(
                mediaPlaceholderColor: UIColor(rgb: 0xe8ecf0),
                itemAccentColor: UIColor(rgb: 0x007aff)
            ),
            chatList: PresentationThemeChatList(
                backgroundColor: UIColor(rgb: 0xffffff)
            )
        )
    }
}
public struct PresentationThemeList {
    public let mediaPlaceholderColor: UIColor
    public let itemAccentColor: UIColor
    public init(mediaPlaceholderColor: UIColor, itemAccentColor: UIColor) {
        self.mediaPlaceholderColor = mediaPlaceholderColor
        self.itemAccentColor = itemAccentColor
    }
}
public struct PresentationThemeChatList {
    public let backgroundColor: UIColor
    public init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
}
public struct PresentationStrings {
}
public struct PresentationDateTimeFormat {
}
public struct PresentationFontSize {
}
public enum PresentationPersonNameOrder {
    case firstLast
    case lastFirst
}
// MARK: - UIColor Extension
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
