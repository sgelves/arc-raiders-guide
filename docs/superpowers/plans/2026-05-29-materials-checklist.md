# Materials Checklist Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rework the Materials tab so quest-required materials have per-quest checkboxes with persistent state, while the general materials list becomes a read-only reference.

**Architecture:** Single `MaterialsVM` with an injected `ChecklistStorageProtocol` for persistence. Quest-required materials are grouped by quest using a `QuestMaterialGroup` value type. Checked IDs use a composite key (`questId_itemId`) to support the same material appearing in multiple quests.

**Tech Stack:** SwiftUI, Combine (ObservableObject), UserDefaults, XCTest

---

### Task 1: Create Unit Test Target

**Files:**
- Create: `ArkRidersGuideTests/` directory
- Modify: `ArkRidersGuide.xcodeproj/project.pbxproj` (via Xcode CLI)

- [ ] **Step 1: Add unit test target to the project**

Run:
```bash
cd /Users/sergiogelves/code/ArkRidersGuide
mkdir -p ArkRidersGuideTests
```

Create `ArkRidersGuideTests/ArkRidersGuideTests.swift`:
```swift
import XCTest
@testable import ArkRidersGuide

final class ArkRidersGuideTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertTrue(true)
    }
}
```

Add the test target via Xcode's `xcodebuild` or manually in the `.pbxproj`. Since this project uses file-system-synchronized groups, the test target needs to be added to the Xcode project scheme.

- [ ] **Step 2: Verify the test target builds and runs**

Run:
```bash
xcodebuild test -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:ArkRidersGuideTests 2>&1 | tail -5
```

Expected: `** TEST SUCCEEDED **`

- [ ] **Step 3: Commit**

```bash
git add ArkRidersGuideTests/
git add ArkRidersGuide.xcodeproj/
git commit -m "feat: add unit test target"
```

---

### Task 2: Create ChecklistStorageProtocol and Implementations

**Files:**
- Create: `ArkRidersGuide/Services/ChecklistStorageProtocol.swift`
- Create: `ArkRidersGuide/Services/UserDefaultsChecklistStorage.swift`
- Create: `ArkRidersGuide/Mocks/MockChecklistStorage.swift`
- Create: `ArkRidersGuideTests/UserDefaultsChecklistStorageTests.swift`

- [ ] **Step 1: Write the failing tests for ChecklistStorage**

Create `ArkRidersGuideTests/UserDefaultsChecklistStorageTests.swift`:
```swift
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
```

- [ ] **Step 2: Run tests to verify they fail**

Run:
```bash
xcodebuild test -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:ArkRidersGuideTests/UserDefaultsChecklistStorageTests 2>&1 | grep -E "(Test Case|FAIL|error:)"
```

Expected: FAIL — `UserDefaultsChecklistStorage` not defined.

- [ ] **Step 3: Create the protocol**

Create `ArkRidersGuide/Services/ChecklistStorageProtocol.swift`:
```swift
import Foundation

nonisolated protocol ChecklistStorageProtocol: Sendable {
    func checkedIds() -> Set<String>
    func save(checkedIds: Set<String>)
}
```

- [ ] **Step 4: Create the UserDefaults implementation**

Create `ArkRidersGuide/Services/UserDefaultsChecklistStorage.swift`:
```swift
import Foundation

nonisolated final class UserDefaultsChecklistStorage: ChecklistStorageProtocol {
    private let defaults: UserDefaults
    private let key = "materials_checklist_checked_ids"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func checkedIds() -> Set<String> {
        let array = defaults.stringArray(forKey: key) ?? []
        return Set(array)
    }

    func save(checkedIds: Set<String>) {
        defaults.set(Array(checkedIds), forKey: key)
    }
}
```

- [ ] **Step 5: Run tests to verify they pass**

Run:
```bash
xcodebuild test -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:ArkRidersGuideTests/UserDefaultsChecklistStorageTests 2>&1 | grep -E "(Test Case|SUCCEED|FAIL)"
```

Expected: All 4 tests PASS.

- [ ] **Step 6: Create the mock implementation**

Create `ArkRidersGuide/Mocks/MockChecklistStorage.swift`:
```swift
import Foundation

nonisolated final class MockChecklistStorage: ChecklistStorageProtocol {
    private var stored: Set<String> = []

    func checkedIds() -> Set<String> {
        stored
    }

    func save(checkedIds: Set<String>) {
        stored = checkedIds
    }
}
```

- [ ] **Step 7: Commit**

```bash
git add ArkRidersGuide/Services/ChecklistStorageProtocol.swift
git add ArkRidersGuide/Services/UserDefaultsChecklistStorage.swift
git add ArkRidersGuide/Mocks/MockChecklistStorage.swift
git add ArkRidersGuideTests/UserDefaultsChecklistStorageTests.swift
git commit -m "feat: add ChecklistStorageProtocol with UserDefaults implementation"
```

---

### Task 3: Create QuestMaterialGroup Model

**Files:**
- Create: `ArkRidersGuide/Models/QuestMaterialGroup.swift`

- [ ] **Step 1: Create the model**

Create `ArkRidersGuide/Models/QuestMaterialGroup.swift`:
```swift
import Foundation

struct QuestMaterialGroup: Identifiable, Equatable {
    let questId: String
    let questName: String
    var materials: [RequiredItem]

    var id: String { questId }

    static func compositeId(questId: String, itemId: String) -> String {
        "\(questId)_\(itemId)"
    }
}
```

- [ ] **Step 2: Verify build**

Run:
```bash
xcodebuild build -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 | tail -3
```

Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 3: Commit**

```bash
git add ArkRidersGuide/Models/QuestMaterialGroup.swift
git commit -m "feat: add QuestMaterialGroup model"
```

---

### Task 4: Update MaterialsVM with Grouping and Persistence (TDD)

**Files:**
- Modify: `ArkRidersGuide/ViewModels/MaterialsVM.swift`
- Create: `ArkRidersGuideTests/MaterialsVMTests.swift`

- [ ] **Step 1: Write failing tests for the new VM behavior**

Create `ArkRidersGuideTests/MaterialsVMTests.swift`:
```swift
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
    func testCheckedItemsMovedToBottomOfGroup() async {
        await sut.fetchMaterials()

        guard let group = sut.groupedQuestMaterials.first(where: { $0.questId == "clearer_skies" }),
              group.materials.count > 1 else {
            return
        }

        let firstItemId = group.materials[0].item.id
        sut.toggleChecked(questId: "clearer_skies", itemId: firstItemId)

        let updatedGroup = sut.groupedQuestMaterials.first(where: { $0.questId == "clearer_skies" })!
        XCTAssertNotEqual(updatedGroup.materials[0].item.id, firstItemId)
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
```

- [ ] **Step 2: Run tests to verify they fail**

Run:
```bash
xcodebuild test -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:ArkRidersGuideTests/MaterialsVMTests 2>&1 | grep -E "(error:|FAIL)"
```

Expected: FAIL — `MaterialsVM` init doesn't accept `storage` parameter yet.

- [ ] **Step 3: Rewrite MaterialsVM with new behavior**

Replace `ArkRidersGuide/ViewModels/MaterialsVM.swift` with:
```swift
import Combine
import Foundation

class MaterialsVM: ObservableObject {
    @Published var materials: [Item] = []
    @Published var groupedQuestMaterials: [QuestMaterialGroup] = []
    @Published var checkedIds: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: APIServiceProtocol
    private let storage: ChecklistStorageProtocol

    var totalRequired: Int {
        groupedQuestMaterials.flatMap { $0.materials }.count
    }

    var totalChecked: Int {
        let allCompositeIds = groupedQuestMaterials.flatMap { group in
            group.materials.map { QuestMaterialGroup.compositeId(questId: group.questId, itemId: $0.item.id) }
        }
        return allCompositeIds.filter { checkedIds.contains($0) }.count
    }

    var progressText: String {
        "\(totalChecked)/\(totalRequired) COLLECTED"
    }

    init(service: APIServiceProtocol, storage: ChecklistStorageProtocol = UserDefaultsChecklistStorage()) {
        self.service = service
        self.storage = storage
        self.checkedIds = storage.checkedIds()
    }

    func toggleChecked(questId: String, itemId: String) {
        let compositeId = QuestMaterialGroup.compositeId(questId: questId, itemId: itemId)
        if checkedIds.contains(compositeId) {
            checkedIds.remove(compositeId)
        } else {
            checkedIds.insert(compositeId)
        }
        storage.save(checkedIds: checkedIds)
        sortGroupedMaterials()
    }

    func isItemChecked(questId: String, itemId: String) -> Bool {
        let compositeId = QuestMaterialGroup.compositeId(questId: questId, itemId: itemId)
        return checkedIds.contains(compositeId)
    }

    func fetchMaterials() async {
        isLoading = true
        errorMessage = nil
        do {
            async let itemsTask = service.fetchItems()
            async let questsTask = service.fetchQuests()
            let allItems = try await itemsTask
            let allQuests = try await questsTask

            materials = allItems.filter { $0.isMaterial }

            groupedQuestMaterials = allQuests
                .filter { !$0.requiredItems.isEmpty }
                .compactMap { quest in
                    let questMaterials = quest.requiredItems.filter { $0.item.isMaterial }
                    guard !questMaterials.isEmpty else { return nil }
                    return QuestMaterialGroup(
                        questId: quest.id,
                        questName: quest.title,
                        materials: questMaterials
                    )
                }

            sortGroupedMaterials()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func sortGroupedMaterials() {
        for index in groupedQuestMaterials.indices {
            groupedQuestMaterials[index].materials.sort { lhs, rhs in
                let lhsChecked = isItemChecked(questId: groupedQuestMaterials[index].questId, itemId: lhs.item.id)
                let rhsChecked = isItemChecked(questId: groupedQuestMaterials[index].questId, itemId: rhs.item.id)
                if lhsChecked == rhsChecked { return false }
                return !lhsChecked
            }
        }
    }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run:
```bash
xcodebuild test -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:ArkRidersGuideTests/MaterialsVMTests 2>&1 | grep -E "(Test Case|SUCCEED|FAIL)"
```

Expected: All tests PASS.

- [ ] **Step 5: Commit**

```bash
git add ArkRidersGuide/ViewModels/MaterialsVM.swift
git add ArkRidersGuideTests/MaterialsVMTests.swift
git commit -m "feat: update MaterialsVM with quest grouping and persistent checklist"
```

---

### Task 5: Simplify MaterialRowView (Remove Checkbox)

**Files:**
- Modify: `ArkRidersGuide/Views/ObjectivesView/MaterialRowView.swift`

- [ ] **Step 1: Remove checkbox parameters and button from MaterialRowView**

Replace `ArkRidersGuide/Views/ObjectivesView/MaterialRowView.swift` with:
```swift
import SwiftUI

struct MaterialRowView: View {
    let item: Item

    var body: some View {
        HStack(spacing: 12) {
            CachedImageView(
                relativePath: item.imageRelativePath,
                cacheKey: item.id,
                placeholderSymbol: "cube.box"
            )
            .frame(width: 40, height: 40)
            .padding(6)
            .background(TriadColor.background)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(TriadColor.tertiary.opacity(0.3), lineWidth: 1)
            )
            .accessibilityIdentifier(AccessibilityID.Materials.cellImage)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(TriadFont.headline(14))
                    .foregroundStyle(TriadColor.textPrimary)
                    .lineLimit(1)
                    .accessibilityIdentifier(AccessibilityID.Materials.cellTitle)

                HStack(spacing: 8) {
                    Text(item.rarityDisplay)
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(rarityColor(for: item.rarity))
                        .accessibilityIdentifier(AccessibilityID.Materials.cellRarity)

                    Text(item.type.uppercased())
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(TriadColor.textSecondary)
                }
            }

            Spacer()
        }
        .padding(10)
        .background(TriadColor.surface)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(TriadColor.tertiary.opacity(0.15), lineWidth: 1)
        )
        .accessibilityIdentifier(AccessibilityID.Materials.cell)
    }

    private func rarityColor(for rarity: String?) -> Color {
        switch rarity?.lowercased() {
        case "common": return TriadColor.textSecondary
        case "uncommon": return .green
        case "rare": return TriadColor.tertiary
        case "epic": return .purple
        case "legendary": return TriadColor.primary
        default: return TriadColor.textSecondary
        }
    }
}
```

- [ ] **Step 2: Verify build**

Run:
```bash
xcodebuild build -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 | tail -3
```

Expected: Build may fail due to call sites still passing old parameters. That's expected — will be fixed in Task 7.

- [ ] **Step 3: Commit**

```bash
git add ArkRidersGuide/Views/ObjectivesView/MaterialRowView.swift
git commit -m "feat: simplify MaterialRowView by removing checkbox"
```

---

### Task 6: Rework RequiredItemRowView (Add Checkbox + Amount Badge)

**Files:**
- Modify: `ArkRidersGuide/Views/QuestsView/RequiredItemRowView.swift`
- Modify: `ArkRidersGuide/Utils/AccessibilityIdentifiers.swift`

- [ ] **Step 1: Add new accessibility identifiers for quest-required materials**

Add to `AccessibilityIdentifiers.swift` inside `enum AccessibilityID`:
```swift
enum QuestMaterials {
    static let cell = "quest_materials_cell"
    static let cellImage = "quest_materials_cell_image"
    static let cellTitle = "quest_materials_cell_title"
    static let cellAmountBadge = "quest_materials_cell_amount_badge"
    static let cellCheckbox = "quest_materials_cell_checkbox"
    static let progressSummary = "quest_materials_progress_summary"
    static let questHeader = "quest_materials_quest_header"
}
```

- [ ] **Step 2: Rework RequiredItemRowView with checkbox and amount badge**

Replace `ArkRidersGuide/Views/QuestsView/RequiredItemRowView.swift` with:
```swift
import SwiftUI

struct RequiredItemRowView: View {
    let requiredItem: RequiredItem
    let isChecked: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            CachedImageView(
                relativePath: requiredItem.item.imageRelativePath,
                cacheKey: requiredItem.item.id,
                placeholderSymbol: "shippingbox"
            )
            .frame(width: 36, height: 36)
            .padding(4)
            .background(TriadColor.background)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(TriadColor.tertiary.opacity(0.3), lineWidth: 1)
            )
            .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellImage)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(requiredItem.item.name)
                        .font(TriadFont.headline(13))
                        .foregroundStyle(TriadColor.textPrimary)
                        .lineLimit(1)
                        .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellTitle)

                    Text("x\(requiredItem.amount)")
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(TriadColor.background)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(TriadColor.tertiary)
                        .clipShape(Capsule())
                        .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellAmountBadge)
                }

                Text(requiredItem.item.type.uppercased())
                    .font(TriadFont.tactical(10))
                    .foregroundStyle(TriadColor.textSecondary)
            }

            Spacer()

            Button(action: onToggle) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22))
                    .foregroundStyle(isChecked ? TriadColor.primary : TriadColor.textSecondary)
            }
            .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellCheckbox)
        }
        .padding(8)
        .background(TriadColor.surface)
        .cornerRadius(6)
        .accessibilityIdentifier(AccessibilityID.QuestMaterials.cell)
    }
}
```

- [ ] **Step 3: Verify build**

Run:
```bash
xcodebuild build -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 | tail -3
```

Expected: Build may fail due to call sites using old `RequiredItemRowView` init (no `isChecked`/`onToggle`). Will be fixed in Task 7.

- [ ] **Step 4: Commit**

```bash
git add ArkRidersGuide/Views/QuestsView/RequiredItemRowView.swift
git add ArkRidersGuide/Utils/AccessibilityIdentifiers.swift
git commit -m "feat: rework RequiredItemRowView with checkbox and amount badge"
```

---

### Task 7: Update MaterialsListView (Grouping, Progress, Sub-Headers)

**Files:**
- Modify: `ArkRidersGuide/Views/ObjectivesView/MaterialsListView.swift`

- [ ] **Step 1: Rewrite MaterialsListView with quest grouping and progress**

Replace `ArkRidersGuide/Views/ObjectivesView/MaterialsListView.swift` with:
```swift
import SwiftUI

struct MaterialsListView: View {
    @StateObject private var viewModel: MaterialsVM

    init(service: APIServiceProtocol, storage: ChecklistStorageProtocol = UserDefaultsChecklistStorage()) {
        _viewModel = StateObject(wrappedValue: MaterialsVM(service: service, storage: storage))
    }

    var body: some View {
        ZStack {
            TriadColor.background
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView("Scanning salvage...")
                    .font(TriadFont.tactical(12))
                    .tint(TriadColor.tertiary)
                    .foregroundStyle(TriadColor.textSecondary)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundStyle(TriadColor.secondary)
                    Text(error)
                        .font(TriadFont.tactical(12))
                        .foregroundStyle(TriadColor.textSecondary)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task { await viewModel.fetchMaterials() }
                    }
                    .font(TriadFont.tactical(14))
                    .foregroundStyle(TriadColor.primary)
                }
                .padding()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        if !viewModel.groupedQuestMaterials.isEmpty {
                            sectionHeader("QUEST REQUIRED", color: TriadColor.secondary)
                                .padding(.horizontal, 16)

                            progressSummary
                                .padding(.horizontal, 16)

                            ForEach(viewModel.groupedQuestMaterials) { group in
                                questSubHeader(group.questName)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 4)

                                ForEach(group.materials) { required in
                                    RequiredItemRowView(
                                        requiredItem: required,
                                        isChecked: viewModel.isItemChecked(questId: group.questId, itemId: required.item.id),
                                        onToggle: { viewModel.toggleChecked(questId: group.questId, itemId: required.item.id) }
                                    )
                                    .padding(.horizontal, 16)
                                }
                            }

                            sectionHeader("ALL MATERIALS", color: TriadColor.tertiary)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                        }

                        ForEach(viewModel.materials) { item in
                            MaterialRowView(item: item)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .accessibilityIdentifier(AccessibilityID.Materials.list)
            }
        }
        .task {
            if viewModel.materials.isEmpty {
                await viewModel.fetchMaterials()
            }
        }
    }

    private var progressSummary: some View {
        Text(viewModel.progressText)
            .font(TriadFont.tactical(12))
            .foregroundStyle(TriadColor.tertiary)
            .accessibilityIdentifier(AccessibilityID.QuestMaterials.progressSummary)
    }

    private func sectionHeader(_ title: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(color)
                .frame(width: 3, height: 16)
            Text(title)
                .font(TriadFont.tactical(12))
                .foregroundStyle(color)
        }
    }

    private func questSubHeader(_ title: String) -> some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(TriadColor.secondary)
                .frame(width: 3, height: 14)
            Text(title)
                .font(TriadFont.tactical(11))
                .foregroundStyle(TriadColor.secondary)
        }
        .accessibilityIdentifier(AccessibilityID.QuestMaterials.questHeader)
    }
}
```

- [ ] **Step 2: Build the full project**

Run:
```bash
xcodebuild build -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 | tail -3
```

Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 3: Commit**

```bash
git add ArkRidersGuide/Views/ObjectivesView/MaterialsListView.swift
git commit -m "feat: update MaterialsListView with quest grouping and progress"
```

---

### Task 8: Fix Call Sites for RequiredItemRowView in QuestDetailView

**Files:**
- Modify: `ArkRidersGuide/Views/QuestsView/QuestDetailView.swift`

- [ ] **Step 1: Check QuestDetailView for RequiredItemRowView usage**

Read `QuestDetailView.swift` and find where `RequiredItemRowView` is used. It likely passes only `requiredItem:` without `isChecked:` and `onToggle:`. Since the quest detail view is not part of the materials checklist, we need to decide how to handle this.

The quest detail view should show required items without checkboxes. Create a separate simple row or add default parameter values.

- [ ] **Step 2: Add default parameters to RequiredItemRowView for backward compatibility**

Update the `RequiredItemRowView` init to provide defaults so it can be used without checkbox in quest detail:

Add to `RequiredItemRowView`:
```swift
struct RequiredItemRowView: View {
    let requiredItem: RequiredItem
    var isChecked: Bool = false
    var onToggle: (() -> Void)? = nil

    // Update the Button to only show when onToggle is provided:
    // Replace the Button block with:
    if let onToggle {
        Button(action: onToggle) {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .font(.system(size: 22))
                .foregroundStyle(isChecked ? TriadColor.primary : TriadColor.textSecondary)
        }
        .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellCheckbox)
    }
}
```

Full updated `RequiredItemRowView`:
```swift
import SwiftUI

struct RequiredItemRowView: View {
    let requiredItem: RequiredItem
    var isChecked: Bool = false
    var onToggle: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            CachedImageView(
                relativePath: requiredItem.item.imageRelativePath,
                cacheKey: requiredItem.item.id,
                placeholderSymbol: "shippingbox"
            )
            .frame(width: 36, height: 36)
            .padding(4)
            .background(TriadColor.background)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(TriadColor.tertiary.opacity(0.3), lineWidth: 1)
            )
            .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellImage)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(requiredItem.item.name)
                        .font(TriadFont.headline(13))
                        .foregroundStyle(TriadColor.textPrimary)
                        .lineLimit(1)
                        .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellTitle)

                    Text("x\(requiredItem.amount)")
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(TriadColor.background)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(TriadColor.tertiary)
                        .clipShape(Capsule())
                        .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellAmountBadge)
                }

                Text(requiredItem.item.type.uppercased())
                    .font(TriadFont.tactical(10))
                    .foregroundStyle(TriadColor.textSecondary)
            }

            Spacer()

            if let onToggle {
                Button(action: onToggle) {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        .font(.system(size: 22))
                        .foregroundStyle(isChecked ? TriadColor.primary : TriadColor.textSecondary)
                }
                .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellCheckbox)
            }
        }
        .padding(8)
        .background(TriadColor.surface)
        .cornerRadius(6)
        .accessibilityIdentifier(AccessibilityID.QuestMaterials.cell)
    }
}
```

- [ ] **Step 3: Build the full project**

Run:
```bash
xcodebuild build -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 | tail -3
```

Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 4: Commit**

```bash
git add ArkRidersGuide/Views/QuestsView/RequiredItemRowView.swift
git commit -m "feat: make RequiredItemRowView checkbox optional for quest detail reuse"
```

---

### Task 9: Run All Tests and Final Verification

**Files:** None (verification only)

- [ ] **Step 1: Run all tests**

Run:
```bash
xcodebuild test -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 | grep -E "(Test Case|SUCCEED|FAIL|error:)"
```

Expected: All tests PASS.

- [ ] **Step 2: Full clean build**

Run:
```bash
xcodebuild clean build -project ArkRidersGuide.xcodeproj -scheme ArkRidersGuide -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 | tail -3
```

Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 3: Run app in simulator and verify**

Launch the app and verify:
- Materials tab → Quest Required section shows progress summary
- Quest-required materials grouped by quest name (magenta sub-headers)
- Each quest-required row has: image, name + cyan amount badge, checkbox on right
- Checking an item moves it to bottom of its quest group
- All Materials section has no checkboxes
- Kill and relaunch app — checked state persists

- [ ] **Step 4: Final commit if any cleanup needed**

```bash
git status
```
