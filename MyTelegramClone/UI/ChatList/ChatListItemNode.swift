import UIKit
import Foundation
struct EnginePeer: Equatable {
    let id: Int64
    let title: String
    let avatarUrl: String?
    static func == (lhs: EnginePeer, rhs: EnginePeer) -> Bool {
        return lhs.id == rhs.id
    }
}
struct EngineMessage {
    let id: Int64
    let text: String
    let timestamp: Int32
    let author: EnginePeer?
}
struct EngineChatListStoryStats: Equatable {
    let totalCount: Int
    let unseenCount: Int
    let hasUnseenCloseFriends: Bool
    static func == (lhs: EngineChatListStoryStats, rhs: EngineChatListStoryStats) -> Bool {
        return lhs.totalCount == rhs.totalCount &&
               lhs.unseenCount == rhs.unseenCount &&
               lhs.hasUnseenCloseFriends == rhs.hasUnseenCloseFriends
    }
}
enum ChatListItemContent {
    final class ThreadInfo: Equatable {
        let id: Int64
        let title: String
        let isOwnedByMe: Bool
        let isClosed: Bool
        let isHidden: Bool
        let threadPeer: EnginePeer?
        init(id: Int64, title: String, isOwnedByMe: Bool, isClosed: Bool, isHidden: Bool, threadPeer: EnginePeer?) {
            self.id = id
            self.title = title
            self.isOwnedByMe = isOwnedByMe
            self.isClosed = isClosed
            self.isHidden = isHidden
            self.threadPeer = threadPeer
        }
        static func == (lhs: ThreadInfo, rhs: ThreadInfo) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.title == rhs.title &&
                   lhs.isOwnedByMe == rhs.isOwnedByMe &&
                   lhs.isClosed == rhs.isClosed &&
                   lhs.isHidden == rhs.isHidden &&
                   lhs.threadPeer == rhs.threadPeer
        }
    }
    final class DraftState: Equatable {
        let text: String
        init(text: String) {
            self.text = text
        }
        static func == (lhs: DraftState, rhs: DraftState) -> Bool {
            return lhs.text == rhs.text
        }
    }
    struct StoryState: Equatable {
        var stats: EngineChatListStoryStats
        var hasUnseenCloseFriends: Bool
        init(stats: EngineChatListStoryStats, hasUnseenCloseFriends: Bool) {
            self.stats = stats
            self.hasUnseenCloseFriends = hasUnseenCloseFriends
        }
    }
    case peer(
        peer: EnginePeer,
        threadInfo: ThreadInfo?,
        messages: [EngineMessage],
        readState: Int?, // unread count
        isRemovedFromTotalUnreadCount: Bool,
        draftState: DraftState?,
        isPinned: Bool,
        storyState: StoryState?
    )
    case groupReference(
        groupId: Int64,
        peers: [EnginePeer],
        message: EngineMessage?,
        unreadCount: Int,
        hiddenByDefault: Bool
    )
}
class ChatListItem {
    let content: ChatListItemContent
    let index: Int
    let interaction: ChatListNodeInteraction
    init(content: ChatListItemContent, index: Int, interaction: ChatListNodeInteraction) {
        self.content = content
        self.index = index
        self.interaction = interaction
    }
}
// MARK: - ChatListNodeInteraction
class ChatListNodeInteraction {
    var activateSearch: (() -> Void)?
    var peerSelected: ((Int64) -> Void)?
    var togglePeerSelected: ((Int64) -> Void)?
    var additionalCategorySelected: (() -> Void)?
    init() {}
}
class ChatListItemNode: UITableViewCell {
    private enum Constants {
        static let avatarSize: CGFloat = 60.0
        static let leftInset: CGFloat = 16.0
        static let rightInset: CGFloat = 16.0
        static let avatarLeftInset: CGFloat = 16.0
        static let contentLeftInset: CGFloat = 76.0 // avatarLeftInset + avatarSize
        static let separatorHeight: CGFloat = UIScreen.main.scale == 1.0 ? 1.0 : 0.5
        static let itemHeight: CGFloat = 76.0
        static let verticalSpacing: CGFloat = 3.0
        static let badgeHeight: CGFloat = 20.0
        static let badgeMinWidth: CGFloat = 20.0
        static let mutedIconSize: CGFloat = 18.0
        static let verifiedIconSize: CGFloat = 16.0
        static let onlineDotSize: CGFloat = 12.0
    }
    // MARK: - UI Components
    private let containerView = UIView()
    private let highlightedBackgroundView = UIView()
    private let separatorView = UIView()
    // Avatar
    private let avatarContainerView = UIView()
    private let avatarImageView = UIImageView()
    private let avatarTextLabel = UILabel()
    private let onlineDotView = UIView()
    // Content
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let messageLabel = UILabel()
    private let dateLabel = UILabel()
    private let draftLabel = UILabel()
    // Badges
    private let unreadBadgeView = UIView()
    private let unreadBadgeLabel = UILabel()
    private let mutedIconView = UIImageView()
    private let verifiedIconView = UIImageView()
    private let pinnedIconView = UIImageView()
    // Typing indicator
    private let typingIndicatorView = TypingIndicatorView()
    // Swipe actions
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var revealOffset: CGFloat = 0.0
    // Data
    private var item: ChatListItem?
    private var theme: TelegramTheme.Type = TelegramTheme.self
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupGestures()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        // Container
        contentView.addSubview(containerView)
        containerView.backgroundColor = theme.ChatList.itemBackgroundColor
        // Highlighted background
        contentView.addSubview(highlightedBackgroundView)
        highlightedBackgroundView.backgroundColor = theme.ChatList.itemHighlightedBackgroundColor
        highlightedBackgroundView.alpha = 0.0
        // Avatar container
        containerView.addSubview(avatarContainerView)
        // Avatar image
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = Constants.avatarSize / 2.0
        avatarContainerView.addSubview(avatarImageView)
        // Avatar text (fallback)
        avatarTextLabel.textAlignment = .center
        avatarTextLabel.font = .systemFont(ofSize: 24, weight: .medium)
        avatarTextLabel.textColor = .white
        avatarContainerView.addSubview(avatarTextLabel)
        // Online dot
        onlineDotView.backgroundColor = theme.ChatList.onlineDotColor
        onlineDotView.layer.cornerRadius = Constants.onlineDotSize / 2.0
        onlineDotView.layer.borderWidth = 2.0
        onlineDotView.layer.borderColor = theme.ChatList.itemBackgroundColor.cgColor
        onlineDotView.isHidden = true
        avatarContainerView.addSubview(onlineDotView)
        // Title
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = theme.ChatList.titleColor
        containerView.addSubview(titleLabel)
        authorLabel.font = .systemFont(ofSize: 15, weight: .regular)
        authorLabel.textColor = theme.ChatList.authorNameColor
        containerView.addSubview(authorLabel)
        // Message preview
        messageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        messageLabel.textColor = theme.ChatList.messageTextColor
        messageLabel.numberOfLines = 2
        containerView.addSubview(messageLabel)
        // Draft
        draftLabel.font = .systemFont(ofSize: 15, weight: .regular)
        draftLabel.textColor = theme.ChatList.messageDraftTextColor
        draftLabel.text = "Draft: "
        draftLabel.isHidden = true
        containerView.addSubview(draftLabel)
        // Date
        dateLabel.font = .systemFont(ofSize: 15, weight: .regular)
        dateLabel.textColor = theme.ChatList.dateTextColor
        containerView.addSubview(dateLabel)
        // Unread badge
        unreadBadgeView.backgroundColor = theme.ChatList.unreadBadgeActiveBackgroundColor
        unreadBadgeView.layer.cornerRadius = Constants.badgeHeight / 2.0
        unreadBadgeView.isHidden = true
        containerView.addSubview(unreadBadgeView)
        unreadBadgeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        unreadBadgeLabel.textColor = theme.ChatList.unreadBadgeActiveTextColor
        unreadBadgeLabel.textAlignment = .center
        unreadBadgeView.addSubview(unreadBadgeLabel)
        // Muted icon
        mutedIconView.tintColor = theme.ChatList.muteIconColor
        mutedIconView.contentMode = .scaleAspectFit
        mutedIconView.isHidden = true
        containerView.addSubview(mutedIconView)
        // Verified icon
        verifiedIconView.image = UIImage(systemName: "checkmark.seal.fill")
        verifiedIconView.tintColor = theme.ChatList.verifiedIconFillColor
        verifiedIconView.contentMode = .scaleAspectFit
        verifiedIconView.isHidden = true
        containerView.addSubview(verifiedIconView)
        // Pinned icon
        pinnedIconView.image = UIImage(systemName: "pin.fill")
        pinnedIconView.tintColor = theme.ChatList.pinnedBadgeColor
        pinnedIconView.contentMode = .scaleAspectFit
        pinnedIconView.isHidden = true
        containerView.addSubview(pinnedIconView)
        // Typing indicator
        typingIndicatorView.isHidden = true
        containerView.addSubview(typingIndicatorView)
        // Separator
        contentView.addSubview(separatorView)
        separatorView.backgroundColor = theme.ChatList.itemSeparatorColor
    }
    private func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        containerView.addGestureRecognizer(pan)
        panGestureRecognizer = pan
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        let width = bounds.width
        let height = bounds.height
        containerView.frame = CGRect(
            x: revealOffset,
            y: 0,
            width: width,
            height: height
        )
        highlightedBackgroundView.frame = containerView.frame
        // Avatar
        let avatarFrame = CGRect(
            x: Constants.avatarLeftInset,
            y: (height - Constants.avatarSize) / 2.0,
            width: Constants.avatarSize,
            height: Constants.avatarSize
        )
        avatarContainerView.frame = avatarFrame
        avatarImageView.frame = avatarContainerView.bounds
        avatarTextLabel.frame = avatarContainerView.bounds
        // Online dot
        onlineDotView.frame = CGRect(
            x: Constants.avatarSize - Constants.onlineDotSize,
            y: Constants.avatarSize - Constants.onlineDotSize,
            width: Constants.onlineDotSize,
            height: Constants.onlineDotSize
        )
        // Right side (date, badge, icons)
        let rightContentWidth: CGFloat = 80
        let _ = width - Constants.rightInset - rightContentWidth // rightContentX unused
        // Date
        dateLabel.sizeToFit()
        dateLabel.frame = CGRect(
            x: width - Constants.rightInset - dateLabel.bounds.width,
            y: 14,
            width: dateLabel.bounds.width,
            height: 18
        )
        // Unread badge
        if !unreadBadgeView.isHidden {
            unreadBadgeLabel.sizeToFit()
            let badgeWidth = max(Constants.badgeMinWidth, unreadBadgeLabel.bounds.width + 12)
            unreadBadgeView.frame = CGRect(
                x: width - Constants.rightInset - badgeWidth,
                y: height - 14 - Constants.badgeHeight,
                width: badgeWidth,
                height: Constants.badgeHeight
            )
            unreadBadgeLabel.frame = unreadBadgeView.bounds
        }
        // Muted icon
        if !mutedIconView.isHidden {
            mutedIconView.frame = CGRect(
                x: width - Constants.rightInset - Constants.mutedIconSize,
                y: height - 14 - Constants.mutedIconSize,
                width: Constants.mutedIconSize,
                height: Constants.mutedIconSize
            )
        }
        // Pinned icon
        if !pinnedIconView.isHidden {
            pinnedIconView.frame = CGRect(
                x: width - Constants.rightInset - 16,
                y: height - 14 - 16,
                width: 16,
                height: 16
            )
        }
        // Left content (title, message)
        let leftContentX = Constants.contentLeftInset
        let leftContentMaxX = dateLabel.frame.minX - 8
        let leftContentWidth = leftContentMaxX - leftContentX
        // Title
        titleLabel.frame = CGRect(
            x: leftContentX,
            y: 14,
            width: leftContentWidth - 20, // space for verified icon
            height: 22
        )
        // Verified icon
        if !verifiedIconView.isHidden {
            verifiedIconView.frame = CGRect(
                x: titleLabel.frame.maxX + 4,
                y: 14 + (22 - Constants.verifiedIconSize) / 2,
                width: Constants.verifiedIconSize,
                height: Constants.verifiedIconSize
            )
        }
        // Message or typing
        let messageY: CGFloat = 40
        if !typingIndicatorView.isHidden {
            typingIndicatorView.frame = CGRect(
                x: leftContentX,
                y: messageY,
                width: 60,
                height: 20
            )
        } else {
            // Draft
            if !draftLabel.isHidden {
                draftLabel.sizeToFit()
                draftLabel.frame = CGRect(
                    x: leftContentX,
                    y: messageY,
                    width: draftLabel.bounds.width,
                    height: 20
                )
                messageLabel.frame = CGRect(
                    x: draftLabel.frame.maxX,
                    y: messageY,
                    width: leftContentWidth - draftLabel.bounds.width,
                    height: 20
                )
            } else {
                messageLabel.frame = CGRect(
                    x: leftContentX,
                    y: messageY,
                    width: leftContentWidth,
                    height: 20
                )
            }
        }
        // Separator
        separatorView.frame = CGRect(
            x: Constants.contentLeftInset,
            y: height - Constants.separatorHeight,
            width: width - Constants.contentLeftInset,
            height: Constants.separatorHeight
        )
    }
    // MARK: - Configuration (PUBLIC API)
    func configure(with item: ChatListItem) {
        self.item = item
        switch item.content {
        case let .peer(peer, threadInfo, messages, readState, _, draftState, isPinned, storyState):
            configurePeerItem(
                peer: peer,
                threadInfo: threadInfo,
                messages: messages,
                readState: readState,
                draftState: draftState,
                isPinned: isPinned,
                storyState: storyState
            )
        case let .groupReference(groupId, peers, message, unreadCount, _):
            configureGroupItem(
                groupId: groupId,
                peers: peers,
                message: message,
                unreadCount: unreadCount
            )
        }
        setNeedsLayout()
    }
    private func configurePeerItem(
        peer: EnginePeer,
        threadInfo: ChatListItemContent.ThreadInfo?,
        messages: [EngineMessage],
        readState: Int?,
        draftState: ChatListItemContent.DraftState?,
        isPinned: Bool,
        storyState: ChatListItemContent.StoryState?
    ) {
        // Avatar
        configureAvatar(for: peer)
        // Title
        titleLabel.text = peer.title
        // Message preview
        if let draft = draftState {
            draftLabel.isHidden = false
            messageLabel.text = draft.text
        } else if let lastMessage = messages.first {
            draftLabel.isHidden = true
            if let author = lastMessage.author, author.id != peer.id {
                authorLabel.isHidden = false
                authorLabel.text = "\(author.title):"
            } else {
                authorLabel.isHidden = true
            }
            messageLabel.text = lastMessage.text
        } else {
            draftLabel.isHidden = true
            authorLabel.isHidden = true
            messageLabel.text = ""
        }
        // Date
        if let lastMessage = messages.first {
            dateLabel.text = formatMessageDate(timestamp: lastMessage.timestamp)
        } else {
            dateLabel.text = ""
        }
        // Unread badge
        if let unreadCount = readState, unreadCount > 0 {
            unreadBadgeView.isHidden = false
            unreadBadgeLabel.text = unreadCount > 999 ? "999+" : "\(unreadCount)"
        } else {
            unreadBadgeView.isHidden = true
        }
        // Pinned icon
        pinnedIconView.isHidden = !isPinned
        onlineDotView.isHidden = true
        // Typing indicator
    }
    // MARK: - Group Item Configuration
    private func configureGroupItem(
        groupId: Int64,
        peers: [EnginePeer],
        message: EngineMessage?,
        unreadCount: Int
    ) {
        configureGroupAvatar(peers: peers)
        // Title
        // Message
        if let msg = message {
            messageLabel.text = msg.text
            dateLabel.text = formatMessageDate(timestamp: msg.timestamp)
        }
        // Unread
        if unreadCount > 0 {
            unreadBadgeView.isHidden = false
            unreadBadgeLabel.text = unreadCount > 999 ? "999+" : "\(unreadCount)"
        } else {
            unreadBadgeView.isHidden = true
        }
    }
    private func configureAvatar(for peer: EnginePeer) {
        if let avatarUrl = peer.avatarUrl, let _ = URL(string: avatarUrl) {
            avatarImageView.isHidden = false
            avatarTextLabel.isHidden = true
        } else {
            avatarImageView.isHidden = true
            avatarTextLabel.isHidden = false
            let firstLetter = String(peer.title.prefix(1).uppercased())
            avatarTextLabel.text = firstLetter
            let colors: [UIColor] = [
                UIColor(rgb: 0xfc5c51),
                UIColor(rgb: 0xfa790f),
                UIColor(rgb: 0x895dd5),
                UIColor(rgb: 0x0fb297),
                UIColor(rgb: 0x00c0c5),
                UIColor(rgb: 0x3ca5ec),
                UIColor(rgb: 0x3d72ed)
            ]
            let colorIndex = abs(Int(peer.id) % colors.count)
            avatarContainerView.backgroundColor = colors[colorIndex]
            avatarContainerView.layer.cornerRadius = Constants.avatarSize / 2.0
        }
    }
    private func configureGroupAvatar(peers: [EnginePeer]) {
        if let firstPeer = peers.first {
            configureAvatar(for: firstPeer)
        }
    }
    private func formatMessageDate(timestamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        let _ = Date() // now unused
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy"
            return formatter.string(from: date)
        }
    }
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        switch gesture.state {
        case .began:
            break
        case .changed:
            if translation.x > 0 {
                revealOffset = min(translation.x, 80)
            }
            else if translation.x < 0 {
                revealOffset = max(translation.x, -80)
            }
            setNeedsLayout()
            layoutIfNeeded()
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: self)
            if abs(revealOffset) > 40 || abs(velocity.x) > 500 {
                if revealOffset > 0 {
                    // Reply action
                    item?.interaction.peerSelected?(0) // TODO: reply logic
                } else {
                    // Delete/Pin action
                }
            }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
                self.revealOffset = 0
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        default:
            break
        }
    }
    // MARK: - Highlighting
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.highlightedBackgroundView.alpha = highlighted ? 1.0 : 0.0
            }
        } else {
            highlightedBackgroundView.alpha = highlighted ? 1.0 : 0.0
        }
    }
}
// MARK: - UIGestureRecognizerDelegate
extension ChatListItemNode {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = pan.velocity(in: self)
            return abs(velocity.x) > abs(velocity.y)
        }
        return true
    }
}
private class TypingIndicatorView: UIView {
    private let dot1 = UIView()
    private let dot2 = UIView()
    private let dot3 = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDots()
        startAnimating()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupDots() {
        let dotSize: CGFloat = 8.0
        let spacing: CGFloat = 4.0
        let color = TelegramTheme.ChatList.messageTextColor
        [dot1, dot2, dot3].enumerated().forEach { index, dot in
            dot.backgroundColor = color
            dot.layer.cornerRadius = dotSize / 2.0
            dot.frame = CGRect(
                x: CGFloat(index) * (dotSize + spacing),
                y: 6,
                width: dotSize,
                height: dotSize
            )
            addSubview(dot)
        }
    }
    private func startAnimating() {
        animateDot(dot1, delay: 0.0)
        animateDot(dot2, delay: 0.2)
        animateDot(dot3, delay: 0.4)
    }
    private func animateDot(_ dot: UIView, delay: TimeInterval) {
        UIView.animate(
            withDuration: 0.6,
            delay: delay,
            options: [.repeat, .autoreverse],
            animations: {
                dot.alpha = 0.3
            }
        )
    }
}
