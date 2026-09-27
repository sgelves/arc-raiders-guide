import Foundation

struct ArcEnemy: Codable, Identifiable, Sendable, Equatable {
    let id: String
    let name: String
    let updatedAt: String
    let icon: String?

    var imageRelativePath: String? {
        icon
    }
}
