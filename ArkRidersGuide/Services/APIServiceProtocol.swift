import Foundation

nonisolated protocol APIServiceProtocol: Sendable {
    func fetchItems() async throws -> [Item]
    func fetchEnemies() async throws -> [ArcEnemy]
    func fetchEnemyDetail(id: String) async throws -> ArcEnemyDetail
    func fetchQuests() async throws -> [Quest]
}
