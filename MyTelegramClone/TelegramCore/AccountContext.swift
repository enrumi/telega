import Foundation
import UIKit

// MARK: - Адаптер TelegramCore для REST API
// Это заглушка для оригинальных компонентов Telegram

public final class AccountContext {
    public let account: Account
    public let sharedContext: SharedAccountContext
    
    public init(account: Account, sharedContext: SharedAccountContext) {
        self.account = account
        self.sharedContext = sharedContext
    }
}

public final class Account {
    public let id: Int64
    public let peerId: PeerId
    
    public init(id: Int64, peerId: PeerId) {
        self.id = id
        self.peerId = peerId
    }
}

public struct PeerId: Hashable {
    public let id: Int64
    
    public init(_ id: Int64) {
        self.id = id
    }
}

public final class SharedAccountContext {
    public let energyUsageSettings: EnergyUsageSettings
    public let animationCache: AnimationCache
    public let animationRenderer: AnimationRenderer
    
    public init() {
        self.energyUsageSettings = EnergyUsageSettings()
        self.animationCache = AnimationCache()
        self.animationRenderer = AnimationRenderer()
    }
}

public final class EnergyUsageSettings {
    public let loopEmoji: Bool = true
}

public final class AnimationCache {
    // Заглушка для кеша анимаций
}

public final class AnimationRenderer {
    // Заглушка для рендера анимаций
}

// MARK: - Engine Types (упрощённые версии из TelegramCore)

public struct EngineMessage {
    public let id: Int64
    public let text: String
    public let timestamp: Int32
    public let isOutgoing: Bool
    
    public init(id: Int64, text: String, timestamp: Int32, isOutgoing: Bool) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.isOutgoing = isOutgoing
    }
}

public struct EnginePeer {
    public typealias Id = PeerId
    
    public let id: PeerId
    public let title: String
    public let smallProfileImage: String?
    
    public init(id: PeerId, title: String, smallProfileImage: String? = nil) {
        self.id = id
        self.title = title
        self.smallProfileImage = smallProfileImage
    }
}

public struct EngineMedia {
    // Заглушка для медиа
}
