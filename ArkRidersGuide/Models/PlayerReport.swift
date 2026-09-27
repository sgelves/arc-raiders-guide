import Foundation

enum ReportReason: String, Codable, CaseIterable, Sendable {
    case teamingWithEnemies = "teaming_with_enemies"
    case exploitingGlitches = "exploiting_glitches"
    case campingExtraction = "camping_extraction"
    case rattingNoEngagement = "ratting_no_engagement"
    case usingHacks = "using_hacks"
    case streamSniping = "stream_sniping"
    case lootStealing = "loot_stealing"
    case other = "other"

    var displayName: String {
        switch self {
        case .teamingWithEnemies: return "Teaming with enemies"
        case .exploitingGlitches: return "Exploiting glitches/bugs"
        case .campingExtraction: return "Camping extraction points"
        case .rattingNoEngagement: return "Ratting with no engagement"
        case .usingHacks: return "Using hacks/aimbots"
        case .streamSniping: return "Stream sniping"
        case .lootStealing: return "Loot stealing from teammates"
        case .other: return "Other"
        }
    }
}

struct PlayerReport: Codable, Identifiable, Sendable, Equatable {
    var id: String
    let reportedNickname: String
    let region: String?
    let reason: ReportReason
    let customReason: String?
    let reporterDeviceId: String
    let reporterNickname: String?
    let createdAt: Date
}
