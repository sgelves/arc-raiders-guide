import Foundation

nonisolated final class APIService: APIServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func fetchItems() async throws -> [Item] {
        try await fetch(from: APIConstants.itemsURL)
    }

    func fetchEnemies() async throws -> [ArcEnemy] {
        try await fetch(from: APIConstants.enemiesURL)
    }

    func fetchEnemyDetail(id: String) async throws -> ArcEnemyDetail {
        guard let url = APIConstants.enemyDetailURL(id: id) else {
            throw APIError.invalidResponse
        }
        return try await fetch(from: url)
    }

    func fetchQuests() async throws -> [Quest] {
        try await fetch(from: APIConstants.questsURL)
    }

    private func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        return try decoder.decode(T.self, from: data)
    }
}

enum APIError: LocalizedError {
    case invalidResponse
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .decodingFailed:
            return "Failed to decode data"
        }
    }
}
