import Foundation

struct Quest: Codable, Identifiable, Sendable, Equatable {
    let id: String
    let maps: [QuestMap]
    let steps: [QuestStep]
    let title: String
    let description: String
    let trader: Trader
    let requiredItems: [RequiredItem]
    let xpReward: Int
    let updatedAt: String

    var traderImagePath: String? {
        trader.image ?? trader.icon
    }
}

struct QuestMap: Codable, Identifiable, Sendable, Equatable {
    let id: String
    let name: String
}

struct QuestStep: Codable, Sendable, Equatable, Identifiable {
    let title: String
    let amount: Int?

    var id: String { title }
}

struct Trader: Codable, Sendable, Equatable, Identifiable {
    let id: String
    let name: String
    let type: String?
    let description: String
    let image: String?
    let icon: String?

    var imageRelativePath: String? {
        image ?? icon
    }
}

struct RequiredItem: Codable, Sendable, Equatable, Identifiable {
    let item: Item
    let amount: Int

    var id: String { item.id }
}
