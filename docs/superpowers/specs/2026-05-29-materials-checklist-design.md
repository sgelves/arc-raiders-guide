# Materials Checklist Feature Design

## Overview

Rework the Materials tab to provide quest-specific checklist tracking with persistent state, while keeping the general materials list as a read-only reference.

## Sections

### Quest Required Section
- Materials grouped by quest (each quest gets a sub-header)
- Progress summary at the top (e.g., "3/7 COLLECTED")
- Each row: item image, item name + inline cyan filled rounded badge showing amount, checkbox on the right
- Checked items move to the bottom of their quest group
- Checkbox state persisted in UserDefaults across sessions

### All Materials Section
- No checkboxes, no amounts
- Displays: item image, name, rarity (color-coded), type (uppercased)
- Unchanged from current layout (except checkbox removal)

---

## Data Layer

### ChecklistStorageProtocol

```swift
protocol ChecklistStorageProtocol {
    func checkedIds() -> Set<String>
    func save(checkedIds: Set<String>)
}
```

### UserDefaultsChecklistStorage

Concrete implementation using `UserDefaults` with key `"materials_checklist_checked_ids"`. Stores checked IDs as an array of strings.

### MockChecklistStorage

In-memory implementation for tests and previews.

---

## ViewModel Changes (MaterialsVM)

### New Dependencies
- `ChecklistStorageProtocol` injected via constructor

### New Types

```swift
struct QuestMaterialGroup: Identifiable {
    let questId: String
    let questName: String
    var materials: [RequiredItem] // sorted: unchecked first, checked last
    var id: String { questId }
}
```

### New Published Properties
- `groupedQuestMaterials: [QuestMaterialGroup]`

### New Computed Properties
- `totalRequired: Int` — total count of all quest-required material entries (a material required by two quests counts as 2)
- `totalChecked: Int` — count of checked entries among quest-required materials
- `progressText: String` — e.g., "3/7 COLLECTED"

### Changed Behavior
- `checkedIds` loaded from storage on init, saved on every toggle
- `toggleChecked(materialId:)` mutates set, saves to storage, re-sorts groups
- `fetchMaterials()` builds `groupedQuestMaterials` grouped by quest, sorted with checked items last
- Checkbox logic removed from "All Materials" list

---

## View Changes

### MaterialsListView

- Top of Quest Required section: progress summary row (`progressText`) in tertiary color
- Iterates over `groupedQuestMaterials`, each group gets a quest name sub-header
- Quest-required rows use reworked `RequiredItemRowView`
- "All Materials" section uses simplified `MaterialRowView`

### RequiredItemRowView (reworked)

- Left: item image
- Middle: 
  - Top: item name + inline cyan filled rounded badge with `"x{amount}"`
  - Bottom: type (uppercased, secondary color)
- Right: checkbox button (`checkmark.square.fill` / `square`)

### MaterialRowView (simplified)

- Remove `isChecked` and `onToggle` parameters
- Keep: image, name, rarity (color-coded), type

### Quest Sub-Header (new)

- Styled like existing section headers (vertical bar accent + tactical font)
- Uses secondary (magenta) color to distinguish from section-level headers

---

## Persistence & State Flow

1. App launches -> `MaterialsVM.init` receives `ChecklistStorageProtocol` -> loads `checkedIds` from storage
2. `fetchMaterials()` fetches items + quests from API -> filters materials -> groups quest-required by quest -> sorts each group (unchecked first, checked last) -> publishes
3. User taps checkbox -> `toggleChecked(materialId:)` -> updates `checkedIds` -> saves to storage -> re-sorts `groupedQuestMaterials` -> updates progress

### UserDefaults Key
`"materials_checklist_checked_ids"`

### Edge Cases
- Material ID in storage no longer in API response: silently ignored
- Quest with all materials checked: still displayed, all rows at bottom with checkmarks

---

## Visual Styling

### Amount Badge
- Background: tertiary color (cyan), filled
- Text: dark color
- Shape: rounded (capsule)
- Font: tactical, small size
- Content: `"x{amount}"`
- Position: inline, to the right of item name text

### Progress Summary
- Styled in tertiary color
- Tactical font
- Format: `"{checked}/{total} COLLECTED"`

### Quest Sub-Headers
- Secondary (magenta) color
- Vertical bar accent (3px wide)
- Tactical font, small size
