import Foundation

struct QuestMaterialGroup: Identifiable, Equatable {
    let questId: String
    let questName: String
    var materials: [RequiredItem]

    var id: String { questId }

    static func compositeId(questId: String, itemId: String) -> String {
        "\(questId)_\(itemId)"
    }
}
