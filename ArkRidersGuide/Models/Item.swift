import Foundation

struct Item: Codable, Identifiable, Sendable, Equatable {
    let id: String
    let name: String
    let description: String?
    let rarity: String?
    let type: String
    let foundIn: [String]
    let value: Int
    let icon: String?
    let updatedAt: String

    var imageRelativePath: String? {
        icon
    }

    var isComplex: Bool {
        ItemCategory.isComplex(type)
    }

    var isMaterial: Bool {
        ItemCategory.isMaterial(type)
    }

    var rarityDisplay: String {
        guard let rarity else { return "Unknown" }
        return rarity.capitalized
    }
}
