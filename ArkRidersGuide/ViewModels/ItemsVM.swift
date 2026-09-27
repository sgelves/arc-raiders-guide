import Combine
import Foundation

class ItemsVM: ObservableObject {
    @Published var items: [Item] = []
    @Published var questRequiredItems: [RequiredItem] = []
    @Published var checkedIds: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: APIServiceProtocol

    init(service: APIServiceProtocol) {
        self.service = service
    }

    func toggleChecked(itemId: String) {
        if checkedIds.contains(itemId) {
            checkedIds.remove(itemId)
        } else {
            checkedIds.insert(itemId)
        }
    }

    func fetchItems() async {
        isLoading = true
        errorMessage = nil
        do {
            async let itemsTask = service.fetchItems()
            async let questsTask = service.fetchQuests()
            let allItems = try await itemsTask
            let allQuests = try await questsTask
            items = allItems.filter { $0.isComplex }
            questRequiredItems = allQuests
                .flatMap { $0.requiredItems }
                .filter { $0.item.isComplex }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
