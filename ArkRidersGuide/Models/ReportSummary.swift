import Foundation

struct ReportSummary: Sendable, Equatable {
    let playerNickname: String
    let totalCount: Int
    let countByReason: [ReportReason: Int]
}
