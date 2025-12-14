import UIKit

// MARK: - Ячейка чата (1:1 с Telegram)
class ChatListCell: UITableViewCell {
    
    static let reuseIdentifier = "ChatListCell"
    
    // MARK: - UI Elements
    
    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = TelegramTheme.accentColor
        view.layer.cornerRadius = 28
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = TelegramFonts.chatListTitle
        label.textColor = TelegramTheme.ChatList.titleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = TelegramFonts.chatListMessage
        label.textColor = TelegramTheme.ChatList.messageTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = TelegramFonts.chatListDate
        label.textColor = TelegramTheme.ChatList.dateTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typingIndicator: UILabel = {
        let label = UILabel()
        label.text = "typing..."
        label.font = TelegramFonts.chatListMessage
        label.textColor = TelegramTheme.accentColor
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let onlineIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = TelegramTheme.Common.successColor
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkmarkView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = TelegramTheme.Chat.outgoingBubbleSecondaryTextColor
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let pinnedIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pin.fill")
        imageView.tintColor = TelegramTheme.ChatList.messageTextColor
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let unreadBadge: UILabel = {
        let label = UILabel()
        label.font = TelegramFonts.chatListBadge
        label.textColor = TelegramTheme.ChatList.unreadBadgeActiveTextColor
        label.backgroundColor = TelegramTheme.ChatList.unreadBadgeActiveBackgroundColor
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var unreadBadgeWidthConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = TelegramTheme.ChatList.itemBackgroundColor
        
        contentView.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        avatarView.addSubview(onlineIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(typingIndicator)
        contentView.addSubview(dateLabel)
        contentView.addSubview(unreadBadge)
        contentView.addSubview(checkmarkView)
        contentView.addSubview(pinnedIcon)
        
        unreadBadgeWidthConstraint = unreadBadge.widthAnchor.constraint(equalToConstant: 20)
        
        NSLayoutConstraint.activate([
            // Avatar
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 56),
            avatarView.heightAnchor.constraint(equalToConstant: 56),
            
            // Avatar Label
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            // Online Indicator
            onlineIndicator.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 2),
            onlineIndicator.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 2),
            onlineIndicator.widthAnchor.constraint(equalToConstant: 10),
            onlineIndicator.heightAnchor.constraint(equalToConstant: 10),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            
            // Message
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: checkmarkView.trailingAnchor, constant: 4),
            messageLabel.trailingAnchor.constraint(equalTo: unreadBadge.leadingAnchor, constant: -8),
            
            // Typing Indicator
            typingIndicator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            typingIndicator.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            
            // Checkmark (для исходящих)
            checkmarkView.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor),
            checkmarkView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            checkmarkView.widthAnchor.constraint(equalToConstant: 14),
            checkmarkView.heightAnchor.constraint(equalToConstant: 14),
            
            // Pinned Icon
            pinnedIcon.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            pinnedIcon.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -4),
            pinnedIcon.widthAnchor.constraint(equalToConstant: 12),
            pinnedIcon.heightAnchor.constraint(equalToConstant: 12),
            
            // Date
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            // Unread Badge
            unreadBadge.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor),
            unreadBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            unreadBadge.heightAnchor.constraint(equalToConstant: 20),
            unreadBadgeWidthConstraint!
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with chat: Chat) {
        // Заголовок
        titleLabel.text = chat.title
        
        // Последнее сообщение
        messageLabel.text = chat.lastMessage ?? "No messages yet"
        
        // Дата
        if let timestamp = chat.timestamp {
            dateLabel.text = formatDate(timestamp: timestamp)
        } else {
            dateLabel.text = ""
        }
        
        // Аватар (первая буква имени)
        let firstLetter = chat.title.first.map { String($0).uppercased() } ?? "?"
        avatarLabel.text = firstLetter
        
        // Цвет аватара (хеш от ID)
        avatarView.backgroundColor = generateColor(for: chat.id)
        
        // Непрочитанные
        if let unreadCount = chat.unreadCount, unreadCount > 0 {
            unreadBadge.isHidden = false
            unreadBadge.text = unreadCount > 99 ? "99+" : "\(unreadCount)"
            
            // Динамическая ширина
            let width = max(20, CGFloat(unreadBadge.text?.count ?? 1) * 10 + 8)
            unreadBadgeWidthConstraint?.constant = width
            
            // Жирный текст для непрочитанных
            titleLabel.font = TelegramFonts.chatListTitle
            messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else {
            unreadBadge.isHidden = true
            titleLabel.font = TelegramFonts.chatListTitle
            messageLabel.font = TelegramFonts.chatListMessage
        }
        
        // Online индикатор (скрыт - требует WebSocket для real-time статуса)
        onlineIndicator.isHidden = true
        
        // Typing индикатор (скрыт - требует WebSocket для real-time)
        typingIndicator.isHidden = true
        messageLabel.isHidden = false
        
        // Checkmark для последнего сообщения (скрыт - нужно добавить поле в API)
        checkmarkView.isHidden = true
        
        // Pinned icon (скрыт - нужно добавить поле isPinned в API)
        pinnedIcon.isHidden = true
    }
    
    // MARK: - Helpers
    
    private func formatDate(timestamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }
    
    private func generateColor(for id: Int64) -> UIColor {
        let colors: [UIColor] = [
            UIColor(rgb: 0x007aff), // Синий
            UIColor(rgb: 0x34c759), // Зелёный
            UIColor(rgb: 0xff3b30), // Красный
            UIColor(rgb: 0xff9500), // Оранжевый
            UIColor(rgb: 0xaf52de), // Фиолетовый
            UIColor(rgb: 0x5ac8fa), // Голубой
            UIColor(rgb: 0xff2d55), // Розовый
        ]
        
        let index = Int(abs(id)) % colors.count
        return colors[index]
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundColor = highlighted ? TelegramTheme.ChatList.itemHighlightedBackgroundColor : TelegramTheme.ChatList.itemBackgroundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = selected ? TelegramTheme.ChatList.itemHighlightedBackgroundColor : TelegramTheme.ChatList.itemBackgroundColor
    }
}
