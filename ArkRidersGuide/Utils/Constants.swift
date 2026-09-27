import Foundation

enum APIConstants {
    static let dataBaseURL = "https://ardb.app/api"
    static let imageBaseURL = "https://ardb.app/static"

    static let itemsPath = "/items"
    static let enemiesPath = "/arc-enemies"
    static let questsPath = "/quests"

    static var itemsURL: URL { URL(string: dataBaseURL + itemsPath)! }
    static var enemiesURL: URL { URL(string: dataBaseURL + enemiesPath)! }
    static var questsURL: URL { URL(string: dataBaseURL + questsPath)! }

    static func enemyDetailURL(id: String) -> URL? {
        URL(string: dataBaseURL + enemiesPath + "/\(id)")
    }

    static func imageURL(for relativePath: String) -> URL? {
        URL(string: imageBaseURL + relativePath)
    }
}

enum ItemCategory {
    static let complexTypes: Set<String> = ["weapon", "quick use", "augment"]

    static func isComplex(_ type: String) -> Bool {
        complexTypes.contains(type.lowercased())
    }

    static func isMaterial(_ type: String) -> Bool {
        !isComplex(type)
    }
}
