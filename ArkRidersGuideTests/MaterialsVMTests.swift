import XCTest
@testable import ArkRidersGuide

final class MaterialsVMTests: XCTestCase {
    private var sut: MaterialsVM!
    private var mockService: MockAPIService!
    private var mockStorage: MockChecklistStorage!

    @MainActor
    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        mockStorage = MockChecklistStorage()
        sut = MaterialsVM(service: mockService, storage: mockStorage)
    }

    @MainActor
    override func tearDown() {
        sut = nil
        mockService = nil
        mockStorage = nil
        super.tearDown()
    }

    @MainActor
    func testFetchMaterialsGroupsQuestRequiredByQuest() async {
        await sut.fetchMaterials()

        let groups = sut.groupedQuestMaterials
        let questIds = groups.map { $0.questId }
        XCTAssertTrue(questIds.contains("clearer_skies"))
    }

    @MainActor
    func testFetchMaterialsExcludesQuestsWithNoMaterials() async {
        await sut.fetchMaterials()

        let groups = sut.groupedQuestMaterials
        let questIds = groups.map { $0.questId }
        XCTAssertFalse(questIds.contains("picking_up_the_pieces"))
        XCTAssertFalse(questIds.contains("trash_into_treasure"))
    }

    @MainActor
    func testToggleCheckedPersistsToStorage() async {
        await sut.fetchMaterials()

        sut.toggleChecked(questId: "clearer_skies", itemId: "arc_alloy")

        let stored = mockStorage.checkedIds()
        XCTAssertTrue(stored.contains("clearer_skies_arc_alloy"))
    }

    @MainActor
    func testToggleCheckedTwiceRemovesFromStorage() async {
        await sut.fetchMaterials()

        sut.toggleChecked(questId: "clearer_skies", itemId: "arc_alloy")
        sut.toggleChecked(questId: "clearer_skies", itemId: "arc_alloy")

        let stored = mockStorage.checkedIds()
        XCTAssertFalse(stored.contains("clearer_skies_arc_alloy"))
    }

    @MainActor
    func testProgressTextReflectsCheckedCount() async {
        await sut.fetchMaterials()

        XCTAssertTrue(sut.progressText.contains("0/"))

        sut.toggleChecked(questId: "clearer_skies", itemId: "arc_alloy")

        XCTAssertTrue(sut.progressText.contains("1/"))
    }

    @MainActor
    func testTotalRequiredCountsAllQuestMaterialEntries() async {
        await sut.fetchMaterials()

        XCTAssertEqual(sut.totalRequired, sut.groupedQuestMaterials.flatMap { $0.materials }.count)
    }

    @MainActor
    func testCheckedIdsLoadedFromStorageOnInit() async {
        mockStorage.save(checkedIds: ["clearer_skies_arc_alloy"])
        sut = MaterialsVM(service: mockService, storage: mockStorage)

        await sut.fetchMaterials()

        XCTAssertTrue(sut.checkedIds.contains("clearer_skies_arc_alloy"))
    }

    @MainActor
    func testAllMaterialsListHasNoCheckboxState() async {
        await sut.fetchMaterials()

        XCTAssertFalse(sut.materials.isEmpty)
    }
}
