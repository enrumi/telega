import UIKit

// MARK: - Ячейка сообщения (1:1 с Telegram)
class MessageCell: UITableViewCell {
    
    static let reuseIdentifier = "MessageCell"
    
    // MARK: - UI Elements
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = TelegramFonts.messageText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = TelegramFonts.messageTime
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let readStatusView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = TelegramTheme.Chat.outgoingBubbleSecondaryTextColor
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tailView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let senderNameLabel: UILabel = {
        let label = UILabel()
        label.font = TelegramFonts.messageName
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var bubbleLeadingConstraint: NSLayoutConstraint!
    private var bubbleTrailingConstraint: NSLayoutConstraint!
    
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
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(senderNameLabel)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(timeLabel)
        bubbleView.addSubview(readStatusView)
        contentView.addSubview(tailView)
        
        bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        
        NSLayoutConstraint.activate([
            // Bubble
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            // Sender Name
            senderNameLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            senderNameLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            senderNameLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            
            // Message
            messageLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 2),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            
            // Time
            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 2),
            timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            
            // Read Status
            readStatusView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            readStatusView.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -4),
            readStatusView.widthAnchor.constraint(equalToConstant: 16),
            readStatusView.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with message: Message) {
        messageLabel.text = message.text
        timeLabel.text = formatTime(timestamp: message.timestamp)
        
        if message.isOutgoing {
            // Исходящее сообщение (справа, зелёное)
            bubbleView.backgroundColor = TelegramTheme.Chat.outgoingBubbleBackgroundColor
            messageLabel.textColor = TelegramTheme.Chat.outgoingBubblePrimaryTextColor
            timeLabel.textColor = TelegramTheme.Chat.outgoingBubbleSecondaryTextColor
            
            bubbleLeadingConstraint.isActive = false
            bubbleTrailingConstraint.isActive = true
            
            senderNameLabel.isHidden = true
            
            // Статус прочтения (требует поля isRead в API)
            readStatusView.isHidden = false
            readStatusView.image = UIImage(systemName: "checkmark") // Отправлено
            readStatusView.tintColor = TelegramTheme.Chat.outgoingBubbleSecondaryTextColor
            
            // Хвостик справа (упрощённая версия)
            tailView.isHidden = false
            tailView.backgroundColor = TelegramTheme.Chat.outgoingBubbleBackgroundColor
        } else {
            // Входящее сообщение (слева, серое)
            bubbleView.backgroundColor = TelegramTheme.Chat.incomingBubbleBackgroundColor
            messageLabel.textColor = TelegramTheme.Chat.incomingBubblePrimaryTextColor
            timeLabel.textColor = TelegramTheme.Chat.incomingBubbleSecondaryTextColor
            
            bubbleLeadingConstraint.isActive = true
            bubbleTrailingConstraint.isActive = false
            
            // Показываем имя отправителя для групповых чатов
            senderNameLabel.text = message.senderName
            senderNameLabel.textColor = generateColor(for: message.senderId)
            senderNameLabel.isHidden = false
            
            // Скрываем статус прочтения для входящих
            readStatusView.isHidden = true
            
            // Хвостик слева (упрощённая версия)
            tailView.isHidden = false
            tailView.backgroundColor = TelegramTheme.Chat.incomingBubbleBackgroundColor
        }
        
        // Скругление углов с учётом хвостика (упрощённо)
        bubbleView.layer.cornerRadius = 18
        bubbleView.layer.maskedCorners = message.isOutgoing 
            ? [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner] 
            : [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
    }
    
    // MARK: - Helpers
    
    private func formatTime(timestamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func generateColor(for id: Int64) -> UIColor {
        let colors: [UIColor] = [
            UIColor(rgb: 0x007aff),
            UIColor(rgb: 0x34c759),
            UIColor(rgb: 0xff3b30),
            UIColor(rgb: 0xff9500),
            UIColor(rgb: 0xaf52de),
            UIColor(rgb: 0x5ac8fa),
            UIColor(rgb: 0xff2d55),
        ]
        
        let index = Int(abs(id)) % colors.count
        return colors[index]
    }
}
