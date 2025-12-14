import Foundation

// MARK: - Network Adapter (REST API → TelegramCore)
// Конвертирует REST API в формат, понятный оригинальным компонентам Telegram

public final class NetworkAdapter {
    private let networkManager: NetworkManager
    
    public init() {
        self.networkManager = NetworkManager.shared
    }
    
    // MARK: - Convert REST to Engine Types
    
    public func fetchChats() async throws -> [ChatListItem] {
        let chats = try await networkManager.fetchChats()
        return chats.map { chat in
            ChatListItem(
                id: chat.id,
                peer: EnginePeer(
                    id: PeerId(chat.id),
                    title: chat.title,
                    smallProfileImage: nil
                ),
                lastMessage: chat.lastMessage,
                timestamp: chat.timestamp ?? 0,
                unreadCount: chat.unreadCount ?? 0
            )
        }
    }
    
    public func fetchMessages(chatId: Int64) async throws -> [EngineMessage] {
        let messages = try await networkManager.fetchMessages(chatId: chatId)
        return messages.map { message in
            EngineMessage(
                id: message.id,
                text: message.text,
                timestamp: message.timestamp,
                isOutgoing: message.isOutgoing
            )
        }
    }
    
    public func sendMessage(chatId: Int64, text: String) async throws -> EngineMessage {
        let message = try await networkManager.sendMessage(chatId: chatId, text: text)
        return EngineMessage(
            id: message.id,
            text: message.text,
            timestamp: message.timestamp,
            isOutgoing: message.isOutgoing
        )
    }
}

// MARK: - ChatListItem (упрощённая версия)

public struct ChatListItem {
    public let id: Int64
    public let peer: EnginePeer
    public let lastMessage: String?
    public let timestamp: Int32
    public let unreadCount: Int
    
    public init(id: Int64, peer: EnginePeer, lastMessage: String?, timestamp: Int32, unreadCount: Int) {
        self.id = id
        self.peer = peer
        self.lastMessage = lastMessage
        self.timestamp = timestamp
        self.unreadCount = unreadCount
    }
}
