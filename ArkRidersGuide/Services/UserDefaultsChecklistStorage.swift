import Foundation

final class UserDefaultsChecklistStorage: ChecklistStorageProtocol {
    private let defaults: UserDefaults
    private let key = "materials_checklist_checked_ids"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func checkedIds() -> Set<String> {
        let array = defaults.stringArray(forKey: key) ?? []
        return Set(array)
    }

    func save(checkedIds: Set<String>) {
        defaults.set(Array(checkedIds), forKey: key)
    }
}
