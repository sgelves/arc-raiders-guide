import Foundation

nonisolated protocol ChecklistStorageProtocol: Sendable {
    func checkedIds() -> Set<String>
    func save(checkedIds: Set<String>)
}
