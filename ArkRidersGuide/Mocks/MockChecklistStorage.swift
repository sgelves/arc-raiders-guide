import Foundation

nonisolated final class MockChecklistStorage: ChecklistStorageProtocol {
    private var stored: Set<String> = []

    func checkedIds() -> Set<String> {
        stored
    }

    func save(checkedIds: Set<String>) {
        stored = checkedIds
    }
}
