import Combine
import Foundation

class QuestsVM: ObservableObject {
    @Published var quests: [Quest] = []
    @Published var followedQuestIds: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: APIServiceProtocol

    init(service: APIServiceProtocol) {
        self.service = service
    }

    var followedQuests: [Quest] {
        quests.filter { followedQuestIds.contains($0.id) }
    }

    var availableQuests: [Quest] {
        quests.filter { !followedQuestIds.contains($0.id) }
    }

    var followedRequiredMaterials: [RequiredItem] {
        followedQuests
            .flatMap { $0.requiredItems }
            .filter { $0.item.isMaterial }
    }

    var followedRequiredItems: [RequiredItem] {
        followedQuests
            .flatMap { $0.requiredItems }
            .filter { $0.item.isComplex }
    }

    func fetchQuests() async {
        isLoading = true
        errorMessage = nil
        do {
            quests = try await service.fetchQuests()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func toggleFollow(questId: String) {
        if followedQuestIds.contains(questId) {
            followedQuestIds.remove(questId)
        } else {
            followedQuestIds.insert(questId)
        }
    }
}
