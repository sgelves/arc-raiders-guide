import Foundation

struct ArcEnemyDetail: Codable, Identifiable, Sendable, Equatable {
    let id: String
    let name: String
    let updatedAt: String
    let image: String?
    let icon: String?
    let dropTable: [Item]
    let relatedLocationTypes: [String]?
    let markers: [EnemyMarker]?
    let relatedMaps: [EnemyRelatedMap]?

    var imageRelativePath: String? {
        image ?? icon
    }
}

struct EnemyMarker: Codable, Sendable, Equatable {
    let coordinate: [Double]
    let mapId: String
}

struct EnemyRelatedMap: Codable, Identifiable, Sendable, Equatable {
    let id: String
    let name: String
    let image: String?
    let description: String?
}
