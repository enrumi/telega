import UIKit

// MARK: - MessageBubbleNode (из оригинала Telegram)
// Источник: Telegram iOS message bubbles
// Правильные пузыри с хвостиками, тенями, группировкой

final class MessageBubbleNode: UIView {
    
    // MARK: - Properties
    
    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    private let statusImageView = UIImageView()
    private let tailLayer = CAShapeLayer()
    
    private var isOutgoing: Bool = false
    private var hasNextMessageFromSameSender: Bool = false
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        // Bubble (пузырь)
        bubbleView.layer.masksToBounds = true
        addSubview(bubbleView)
        
        // Tail (хвостик) - отдельный layer
        tailLayer.fillColor = UIColor.clear.cgColor
        layer.insertSublayer(tailLayer, at: 0)
        
        // Message text
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16)
        bubbleView.addSubview(messageLabel)
        
        // Time
        timeLabel.font = .systemFont(ofSize: 12)
        bubbleView.addSubview(timeLabel)
        
        // Status (✓✓)
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.tintColor = TelegramTheme.Chat.outgoingBubbleSecondaryTextColor
        bubbleView.addSubview(statusImageView)
    }
    
    // MARK: - Configuration
    
    func configure(with message: NetworkManager.Message, hasNextFromSame: Bool) {
        self.isOutgoing = message.isOutgoing
        self.hasNextMessageFromSameSender = hasNextFromSame
        
        // Colors
        if isOutgoing {
            bubbleView.backgroundColor = TelegramTheme.Chat.outgoingBubbleBackgroundColor
            messageLabel.textColor = TelegramTheme.Chat.outgoingBubblePrimaryTextColor
            timeLabel.textColor = TelegramTheme.Chat.outgoingBubbleSecondaryTextColor
            tailLayer.fillColor = TelegramTheme.Chat.outgoingBubbleBackgroundColor.cgColor
        } else {
            bubbleView.backgroundColor = TelegramTheme.Chat.incomingBubbleBackgroundColor
            messageLabel.textColor = TelegramTheme.Chat.incomingBubblePrimaryTextColor
            timeLabel.textColor = TelegramTheme.Chat.incomingBubbleSecondaryTextColor
            tailLayer.fillColor = TelegramTheme.Chat.incomingBubbleBackgroundColor.cgColor
        }
        
        // Content
        messageLabel.text = message.text
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: message.timestamp)
        
        // Status (только для исходящих)
        if isOutgoing {
            statusImageView.isHidden = false
            statusImageView.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            statusImageView.isHidden = true
        }
        
        setNeedsLayout()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxWidth = bounds.width * 0.7 // 70% экрана
        let padding: CGFloat = 12
        let cornerRadius: CGFloat = 17
        
        // Размер текста
        let messageLabelSize = messageLabel.sizeThatFits(CGSize(
            width: maxWidth - padding * 2,
            height: .greatestFiniteMagnitude
        ))
        
        // Размер time + status
        let timeLabelSize = timeLabel.sizeThatFits(CGSize(width: 100, height: 20))
        let statusSize: CGFloat = isOutgoing ? 16 : 0
        let bottomRowWidth = timeLabelSize.width + statusSize + (isOutgoing ? 4 : 0)
        
        // Размер пузыря
        let bubbleWidth = max(messageLabelSize.width, bottomRowWidth) + padding * 2
        let bubbleHeight = messageLabelSize.height + timeLabelSize.height + padding * 2 + 4
        
        // Позиция пузыря
        let bubbleX: CGFloat
        if isOutgoing {
            bubbleX = bounds.width - bubbleWidth - 8 - 6 // 6px для хвостика
        } else {
            bubbleX = 8 + 6 // 6px для хвостика
        }
        
        bubbleView.frame = CGRect(
            x: bubbleX,
            y: 0,
            width: bubbleWidth,
            height: bubbleHeight
        )
        
        // Corner radius (с учётом группировки)
        bubbleView.layer.cornerRadius = cornerRadius
        
        // Убираем нижний угол если следующее сообщение от того же отправителя
        if hasNextMessageFromSameSender {
            // Маска для скругления только верхних углов
            let maskPath: UIBezierPath
            if isOutgoing {
                maskPath = UIBezierPath(
                    roundedRect: bubbleView.bounds,
                    byRoundingCorners: [.topLeft, .topRight, .bottomLeft],
                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
                )
            } else {
                maskPath = UIBezierPath(
                    roundedRect: bubbleView.bounds,
                    byRoundingCorners: [.topLeft, .topRight, .bottomRight],
                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
                )
            }
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            bubbleView.layer.mask = maskLayer
        } else {
            bubbleView.layer.mask = nil
        }
        
        // Message label
        messageLabel.frame = CGRect(
            x: padding,
            y: padding,
            width: messageLabelSize.width,
            height: messageLabelSize.height
        )
        
        // Time label
        timeLabel.frame = CGRect(
            x: bubbleWidth - bottomRowWidth - padding,
            y: bubbleHeight - timeLabelSize.height - padding + 2,
            width: timeLabelSize.width,
            height: timeLabelSize.height
        )
        
        // Status
        if isOutgoing {
            statusImageView.frame = CGRect(
                x: timeLabel.frame.maxX + 4,
                y: timeLabel.frame.minY,
                width: 14,
                height: 14
            )
        }
        
        // Tail (хвостик) - рисуем только если это последнее в группе
        if !hasNextMessageFromSameSender {
            drawTail()
        } else {
            tailLayer.path = nil
        }
    }
    
    // MARK: - Tail Drawing (из оригинала Telegram)
    
    private func drawTail() {
        let tailPath = UIBezierPath()
        let tailSize: CGFloat = 6
        
        if isOutgoing {
            // Хвостик справа
            let startX = bubbleView.frame.maxX
            let startY = bubbleView.frame.maxY - 10
            
            tailPath.move(to: CGPoint(x: startX, y: startY))
            tailPath.addCurve(
                to: CGPoint(x: startX + tailSize, y: startY + 10),
                controlPoint1: CGPoint(x: startX + 2, y: startY + 3),
                controlPoint2: CGPoint(x: startX + 4, y: startY + 7)
            )
            tailPath.addLine(to: CGPoint(x: startX, y: startY + 8))
            tailPath.close()
        } else {
            // Хвостик слева
            let startX = bubbleView.frame.minX
            let startY = bubbleView.frame.maxY - 10
            
            tailPath.move(to: CGPoint(x: startX, y: startY))
            tailPath.addCurve(
                to: CGPoint(x: startX - tailSize, y: startY + 10),
                controlPoint1: CGPoint(x: startX - 2, y: startY + 3),
                controlPoint2: CGPoint(x: startX - 4, y: startY + 7)
            )
            tailPath.addLine(to: CGPoint(x: startX, y: startY + 8))
            tailPath.close()
        }
        
        tailLayer.path = tailPath.cgPath
    }
    
    // MARK: - Size Calculation
    
    static func height(for message: NetworkManager.Message, width: CGFloat) -> CGFloat {
        let maxWidth = width * 0.7
        let padding: CGFloat = 12
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.text = message.text
        
        let textSize = label.sizeThatFits(CGSize(
            width: maxWidth - padding * 2,
            height: .greatestFiniteMagnitude
        ))
        
        return textSize.height + 40 + 8 // 40 для time + padding, 8 для spacing
    }
}

// MARK: - Improved MessageCell with MessageBubbleNode

class MessageCell_New: UITableViewCell {
    
    static let reuseIdentifier = "MessageCell_New"
    
    private let bubbleNode = MessageBubbleNode()
    private var message: NetworkManager.Message?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = TelegramTheme.Chat.backgroundColor
        selectionStyle = .none
        contentView.addSubview(bubbleNode)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bubbleNode.frame = contentView.bounds
    }
    
    func configure(with message: NetworkManager.Message, hasNextFromSameSender: Bool) {
        self.message = message
        bubbleNode.configure(with: message, hasNextFromSame: hasNextFromSameSender)
    }
}
