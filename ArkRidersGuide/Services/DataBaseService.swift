import FirebaseCore
@preconcurrency import FirebaseFirestore
import Foundation

enum DataBaseError: Error, Sendable {
    case unauthorized
    case documentNotFound
    case decodingFailed
}

struct PaginationCursor: Sendable {
    let snapshot: DocumentSnapshot
}

nonisolated final class DataBaseService: Sendable {
    private let db = Firestore.firestore()
    private let collection = "reports"

    // MARK: - Create

    func submitReport(_ report: PlayerReport) async throws {
        let data: [String: Any] = [
            "reportedNickname": report.reportedNickname,
            "region": report.region as Any,
            "reason": report.reason.rawValue,
            "customReason": report.customReason as Any,
            "reporterDeviceId": report.reporterDeviceId,
            "reporterNickname": report.reporterNickname as Any,
            "createdAt": Timestamp(date: report.createdAt)
        ]
        try await db.collection(collection).addDocument(data: data)
    }

    // MARK: - Read

    func fetchRecentReports(limit: Int, after cursor: PaginationCursor?) async throws -> (reports: [PlayerReport], nextCursor: PaginationCursor?) {
        var query = db.collection(collection)
            .order(by: "createdAt", descending: true)
            .limit(to: limit)

        if let cursor {
            query = query.start(afterDocument: cursor.snapshot)
        }

        let snapshot = try await query.getDocuments()
        let reports = snapshot.documents.compactMap { decode($0) }
        let next = snapshot.documents.last.map { PaginationCursor(snapshot: $0) }
        return (reports, next)
    }

    func searchReports(byPlayer nickname: String, limit: Int, after cursor: PaginationCursor?) async throws -> (reports: [PlayerReport], nextCursor: PaginationCursor?) {
        var query = db.collection(collection)
            .whereField("reportedNickname", isEqualTo: nickname)
            .order(by: "createdAt", descending: true)
            .limit(to: limit)

        if let cursor {
            query = query.start(afterDocument: cursor.snapshot)
        }

        let snapshot = try await query.getDocuments()
        let reports = snapshot.documents.compactMap { decode($0) }
        let next = snapshot.documents.last.map { PaginationCursor(snapshot: $0) }
        return (reports, next)
    }

    func fetchReportSummary(forPlayer nickname: String) async throws -> ReportSummary {
        let snapshot = try await db.collection(collection)
            .whereField("reportedNickname", isEqualTo: nickname)
            .getDocuments()

        var countByReason: [ReportReason: Int] = [:]
        for document in snapshot.documents {
            guard let rawReason = document.data()["reason"] as? String,
                  let reason = ReportReason(rawValue: rawReason) else { continue }
            countByReason[reason, default: 0] += 1
        }

        return ReportSummary(
            playerNickname: nickname,
            totalCount: snapshot.documents.count,
            countByReason: countByReason
        )
    }

    // MARK: - Delete

    func deleteReport(id: String, deviceId: String, nickname: String?) async throws {
        let docRef = db.collection(collection).document(id)
        let document = try await docRef.getDocument()

        guard document.exists, let data = document.data() else {
            throw DataBaseError.documentNotFound
        }

        let storedDeviceId = data["reporterDeviceId"] as? String
        let storedNickname = data["reporterNickname"] as? String

        let deviceMatch = storedDeviceId == deviceId
        let nicknameMatch: Bool = {
            guard let nickname, let storedNickname else { return false }
            return nickname == storedNickname
        }()

        guard deviceMatch || nicknameMatch else {
            throw DataBaseError.unauthorized
        }

        try await docRef.delete()
    }

    // MARK: - Private

    private func decode(_ document: DocumentSnapshot) -> PlayerReport? {
        guard let data = document.data() else { return nil }

        guard let reportedNickname = data["reportedNickname"] as? String,
              let rawReason = data["reason"] as? String,
              let reason = ReportReason(rawValue: rawReason),
              let reporterDeviceId = data["reporterDeviceId"] as? String,
              let timestamp = data["createdAt"] as? Timestamp else { return nil }

        return PlayerReport(
            id: document.documentID,
            reportedNickname: reportedNickname,
            region: data["region"] as? String,
            reason: reason,
            customReason: data["customReason"] as? String,
            reporterDeviceId: reporterDeviceId,
            reporterNickname: data["reporterNickname"] as? String,
            createdAt: timestamp.dateValue()
        )
    }
}
