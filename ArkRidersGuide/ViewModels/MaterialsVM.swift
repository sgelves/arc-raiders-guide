import Combine
import Foundation

class MaterialsVM: ObservableObject {
    @Published var materials: [Item] = []
    @Published var groupedQuestMaterials: [QuestMaterialGroup] = []
    @Published var checkedIds: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: APIServiceProtocol
    private let storage: ChecklistStorageProtocol

    var totalRequired: Int {
        groupedQuestMaterials.flatMap { $0.materials }.count
    }

    var totalChecked: Int {
        let allCompositeIds = groupedQuestMaterials.flatMap { group in
            group.materials.map { QuestMaterialGroup.compositeId(questId: group.questId, itemId: $0.item.id) }
        }
        return allCompositeIds.filter { checkedIds.contains($0) }.count
    }

    var progressText: String {
        "\(totalChecked)/\(totalRequired) COLLECTED"
    }

    init(service: APIServiceProtocol, storage: ChecklistStorageProtocol = UserDefaultsChecklistStorage()) {
        self.service = service
        self.storage = storage
        self.checkedIds = storage.checkedIds()
    }

    func toggleChecked(questId: String, itemId: String) {
        let compositeId = QuestMaterialGroup.compositeId(questId: questId, itemId: itemId)
        if checkedIds.contains(compositeId) {
            checkedIds.remove(compositeId)
        } else {
            checkedIds.insert(compositeId)
        }
        storage.save(checkedIds: checkedIds)
        sortGroupedMaterials()
    }

    func isItemChecked(questId: String, itemId: String) -> Bool {
        let compositeId = QuestMaterialGroup.compositeId(questId: questId, itemId: itemId)
        return checkedIds.contains(compositeId)
    }

    func fetchMaterials() async {
        isLoading = true
        errorMessage = nil
        do {
            async let itemsTask = service.fetchItems()
            async let questsTask = service.fetchQuests()
            let allItems = try await itemsTask
            let allQuests = try await questsTask

            materials = allItems.filter { $0.isMaterial }

            groupedQuestMaterials = allQuests
                .filter { !$0.requiredItems.isEmpty }
                .compactMap { quest in
                    let questMaterials = quest.requiredItems.filter { $0.item.isMaterial }
                    guard !questMaterials.isEmpty else { return nil }
                    return QuestMaterialGroup(
                        questId: quest.id,
                        questName: quest.title,
                        materials: questMaterials
                    )
                }

            sortGroupedMaterials()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Private

    private func sortGroupedMaterials() {
        for index in groupedQuestMaterials.indices {
            groupedQuestMaterials[index].materials.sort { lhs, rhs in
                let lhsChecked = isItemChecked(questId: groupedQuestMaterials[index].questId, itemId: lhs.item.id)
                let rhsChecked = isItemChecked(questId: groupedQuestMaterials[index].questId, itemId: rhs.item.id)
                if lhsChecked == rhsChecked { return false }
                return !lhsChecked
            }
        }
    }
}
