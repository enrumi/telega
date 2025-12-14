import Foundation

// MARK: - API Models
public struct LoginRequest: Codable {
    let phone: String
    let code: String
}

public struct LoginResponse: Codable {
    let userId: Int64
    let token: String
    let firstName: String
    let lastName: String?
}

public struct Chat: Codable {
    let id: Int64
    let title: String
    let lastMessage: String?
    let timestamp: Int32?
    let unreadCount: Int?
    let avatarUrl: String?
}

public struct Message: Codable {
    let id: Int64
    let chatId: Int64
    let text: String
    let timestamp: Int32
    let senderId: Int64
    let senderName: String
    let isOutgoing: Bool
}

public struct SendMessageRequest: Codable {
    let text: String
}

public struct SendMessageResponse: Codable {
    let messageId: Int64
}

public struct ChatsResponse: Codable {
    let chats: [Chat]
}

public struct MessagesResponse: Codable {
    let messages: [Message]
}

// MARK: - Network Errors
public enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(String)
    case unauthorized
    case networkFailure(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Неверный URL"
        case .noData: return "Нет данных"
        case .decodingError(let error): return "Ошибка парсинга: \(error.localizedDescription)"
        case .serverError(let msg): return "Ошибка сервера: \(msg)"
        case .unauthorized: return "Не авторизован"
        case .networkFailure(let error): return "Ошибка сети: \(error.localizedDescription)"
        }
    }
}

// MARK: - NetworkManager
public final class NetworkManager {
    public static let shared = NetworkManager()
    
    // Твой сервер (измени на свой IP если нужно)
    let baseURL = "http://192.168.1.109:3000"
    
    // Токен авторизации
    private(set) var authToken: String? {
        didSet {
            if let token = authToken {
                UserDefaults.standard.set(token, forKey: "authToken")
            } else {
                UserDefaults.standard.removeObject(forKey: "authToken")
            }
        }
    }
    
    // Текущий пользователь
    private(set) var currentUserId: Int64? {
        didSet {
            if let userId = currentUserId {
                UserDefaults.standard.set(userId, forKey: "currentUserId")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentUserId")
            }
        }
    }
    
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
        
        // Восстанавливаем токен из UserDefaults
        if let savedToken = UserDefaults.standard.string(forKey: "authToken") {
            self.authToken = savedToken
        }
        if let savedUserId = UserDefaults.standard.object(forKey: "currentUserId") as? Int64 {
            self.currentUserId = savedUserId
        }
    }
    
    // MARK: - Authorization
    
    /// Авторизация: POST /auth/login
    /// Код всегда 22222
    public func login(phone: String, code: String) async throws -> LoginResponse {
        let endpoint = "/auth/login"
        let request = LoginRequest(phone: phone, code: code)
        
        print("📤 LOGIN REQUEST: phone=\(phone), code=\(code)")
        
        let response: LoginResponse = try await post(endpoint: endpoint, body: request)
        
        print("✅ LOGIN SUCCESS: userId=\(response.userId), token=\(response.token)")
        
        self.authToken = response.token
        self.currentUserId = response.userId
        
        return response
    }
    
    // MARK: - Chats
    
    /// Список чатов: GET /chats
    public func fetchChats() async throws -> [Chat] {
        let endpoint = "/chats"
        
        print("📤 FETCH CHATS")
        
        let response: ChatsResponse = try await get(endpoint: endpoint)
        
        print("✅ CHATS RECEIVED: \(response.chats.count) chats")
        
        return response.chats
    }
    
    // MARK: - Messages
    
    /// Сообщения чата: GET /chats/{id}/messages
    public func fetchMessages(chatId: Int64) async throws -> [Message] {
        let endpoint = "/chats/\(chatId)/messages"
        
        print("📤 FETCH MESSAGES: chatId=\(chatId)")
        
        let response: MessagesResponse = try await get(endpoint: endpoint)
        
        print("✅ MESSAGES RECEIVED: \(response.messages.count) messages")
        
        return response.messages
    }
    
    /// Отправка сообщения: POST /chats/{id}/send
    public func sendMessage(chatId: Int64, text: String) async throws -> Int64 {
        let endpoint = "/chats/\(chatId)/send"
        let request = SendMessageRequest(text: text)
        
        print("📤 SEND MESSAGE: chatId=\(chatId), text=\(text)")
        
        let response: SendMessageResponse = try await post(endpoint: endpoint, body: request)
        
        print("✅ MESSAGE SENT: messageId=\(response.messageId)")
        
        return response.messageId
    }
    
    // MARK: - Generic HTTP Methods
    
    func get<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError("Invalid response")
            }
            
            print("📥 GET \(endpoint): HTTP \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorString = String(data: data, encoding: .utf8) {
                    print("❌ Server error: \(errorString)")
                    throw NetworkError.serverError("HTTP \(httpResponse.statusCode): \(errorString)")
                }
                throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                return result
            } catch {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("❌ Failed to decode JSON: \(jsonString)")
                }
                throw NetworkError.decodingError(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            print("❌ Network error: \(error)")
            throw NetworkError.networkFailure(error)
        }
    }
    
    private func post<T: Encodable, R: Decodable>(endpoint: String, body: T) async throws -> R {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
        
        if let bodyString = String(data: request.httpBody!, encoding: .utf8) {
            print("📤 POST \(endpoint) body: \(bodyString)")
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError("Invalid response")
            }
            
            print("📥 POST \(endpoint): HTTP \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorString = String(data: data, encoding: .utf8) {
                    print("❌ Server error: \(errorString)")
                    throw NetworkError.serverError("HTTP \(httpResponse.statusCode): \(errorString)")
                }
                throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(R.self, from: data)
                return result
            } catch {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("❌ Failed to decode JSON: \(jsonString)")
                }
                throw NetworkError.decodingError(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            print("❌ Network error: \(error)")
            throw NetworkError.networkFailure(error)
        }
    }
    
    // MARK: - Token Management
    
    public func setToken(_ token: String, userId: Int64) {
        self.authToken = token
        self.currentUserId = userId
    }
    
    public func clearAuth() {
        self.authToken = nil
        self.currentUserId = nil
    }
    
    public func isAuthorized() -> Bool {
        return authToken != nil
    }
}
