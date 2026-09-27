import Combine
import Foundation

class EnemiesVM: ObservableObject {
    @Published var enemies: [ArcEnemy] = []
    @Published var checkedIds: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: APIServiceProtocol

    init(service: APIServiceProtocol) {
        self.service = service
    }

    func toggleChecked(enemyId: String) {
        if checkedIds.contains(enemyId) {
            checkedIds.remove(enemyId)
        } else {
            checkedIds.insert(enemyId)
        }
    }

    func fetchEnemies() async {
        isLoading = true
        errorMessage = nil
        do {
            enemies = try await service.fetchEnemies()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
