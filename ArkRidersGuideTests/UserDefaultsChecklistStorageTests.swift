import XCTest
@testable import ArkRidersGuide

final class UserDefaultsChecklistStorageTests: XCTestCase {
    private var sut: UserDefaultsChecklistStorage!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: "test_checklist")!
        defaults.removePersistentDomain(forName: "test_checklist")
        sut = UserDefaultsChecklistStorage(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: "test_checklist")
        defaults = nil
        sut = nil
        super.tearDown()
    }

    func testCheckedIdsReturnsEmptySetWhenNoDataStored() {
        let result = sut.checkedIds()
        XCTAssertTrue(result.isEmpty)
    }

    func testSaveAndRetrieveCheckedIds() {
        let ids: Set<String> = ["quest1_item1", "quest2_item3"]
        sut.save(checkedIds: ids)
        let result = sut.checkedIds()
        XCTAssertEqual(result, ids)
    }

    func testSaveOverwritesPreviousData() {
        sut.save(checkedIds: ["a", "b"])
        sut.save(checkedIds: ["c"])
        let result = sut.checkedIds()
        XCTAssertEqual(result, ["c"])
    }

    func testSaveEmptySetClearsStorage() {
        sut.save(checkedIds: ["a", "b"])
        sut.save(checkedIds: [])
        let result = sut.checkedIds()
        XCTAssertTrue(result.isEmpty)
    }
}
