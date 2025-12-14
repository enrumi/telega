import Foundation
struct User: Codable {
    let id: Int64
    let firstName: String?
    let lastName: String?
    let username: String?
    let phone: String?
    let bio: String?
    let avatarUrl: String?
    var nameOrPhone: String {
        if let firstName = firstName {
            if let lastName = lastName {
                return "\(firstName) \(lastName)"
            } else {
                return firstName
            }
        } else if let lastName = lastName {
            return lastName
        } else if let phone = phone, !phone.isEmpty {
            return phone
        } else {
            return ""
        }
    }
    var shortName: String {
        if let firstName = firstName {
            return firstName
        } else if let lastName = lastName {
            return lastName
        } else if let phone = phone, !phone.isEmpty {
            return phone
        } else {
            return ""
        }
    }
    var displayName: String {
        if let username = username, !username.isEmpty {
            return "@\(username)"
        }
        return nameOrPhone
    }
}
// MARK: - Search by Username
extension NetworkManager {
    /// GET /users/search?username=@username
    func searchUserByUsername(_ username: String) async throws -> User {
        let cleanUsername = username.replacingOccurrences(of: "@", with: "")
        let endpoint = "/users/search?username=\(cleanUsername)"
        ")
        let user: User = try await get(endpoint: endpoint)
        ")
        return user
    }
    /// GET /chats/search?username=@username
    func searchChatByUsername(_ username: String) async throws -> Chat {
        let cleanUsername = username.replacingOccurrences(of: "@", with: "")
        let endpoint = "/chats/search?username=\(cleanUsername)"
        ")
        let chat: Chat = try await get(endpoint: endpoint)
        ")
        return chat
    }
    /// GET /users/me
    func getCurrentUser() async throws -> User {
        let endpoint = "/users/me"
        let user: User = try await get(endpoint: endpoint)
        ")
        return user
    }
    /// PUT /users/me/username
    func updateUsername(_ username: String) async throws -> User {
        struct UpdateUsernameRequest: Codable {
            let username: String
        }
        let endpoint = "/users/me/username"
        let request = UpdateUsernameRequest(username: username)
        ")
        let user: User = try await put(endpoint: endpoint, body: request)
        ")
        return user
    }
    /// PUT /users/me/bio
    func updateBio(_ bio: String) async throws -> User {
        struct UpdateBioRequest: Codable {
            let bio: String
        }
        let endpoint = "/users/me/bio"
        let request = UpdateBioRequest(bio: bio)
        let user: User = try await put(endpoint: endpoint, body: request)
        return user
    }
}
extension NetworkManager {
    func put<T: Decodable, B: Encodable>(endpoint: String, body: B) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(body)
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
