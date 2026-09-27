# BRD-001: Objectives Hub — Enemy, Materials & Items Tracking

## Document Information

| Field | Value |
|-------|-------|
| **Document ID** | BRD-001 |
| **Version** | 1.0 |
| **Date** | 2026-06-11 |
| **Author** | Sergio Gelves |
| **Status** | Draft |
| **App** | ArkRidersGuide (iOS) |

---

## 1. Executive Summary

The Objectives Hub is the primary operational interface of ArkRidersGuide. It provides Arc Raiders players with a consolidated tactical view of collectible materials, complex items (weapons/augments/usables), and enemy threats — all sourced from a remote API and presented in an industrial "Triad HUD" aesthetic. The module enables players to track their scavenging progress, identify enemy weaknesses, and check off collected materials as they play.

---

## 2. Business Objectives

| # | Objective | Success Metric |
|---|-----------|---------------|
| BO-1 | Provide real-time item and material cataloging from the ardb.app API | 100% of items/materials/enemies from the API rendered in the UI |
| BO-2 | Enable players to track collection progress via checkbox state | Checklist state persists across app restarts |
| BO-3 | Reduce player context-switching between game and external wikis | Session duration > 3 min per visit |
| BO-4 | Support both iPhone and iPad form factors | UI adapts to all iOS 16.7+ screen sizes |

---

## 3. Scope

### 3.1 In Scope

- **Enemies Manifest** — list of all Arc Enemies with name, icon, and level; tap to view detail (weaknesses, description)
- **Materials Manifest** — list of non-complex items grouped by quest relevance, with per-item checklist toggle
- **Items Manifest** — list of complex items (weapons, quick use, augments) with rarity, value, and found-in locations
- **Unified Top Navigation** — 3-segment tab switcher (Enemies | Materials | Items)
- **Image Caching** — Kingfisher-based image cache keyed by entity `id`
- **Persistent Checklist** — UserDefaults-backed storage for checked/unchecked material state
- **Quest-Grouped Materials** — materials organized under the quest that requires them

### 3.2 Out of Scope

- Offline-first data sync / local database (CoreData, SwiftData)
- User accounts or cloud-synced progress
- Push notifications
- Social/multiplayer features
- In-app purchases

---

## 4. Stakeholders

| Role | Name/Team | Interest |
|------|-----------|----------|
| Product Owner | Sergio Gelves | Feature direction, acceptance criteria |
| End Users | Arc Raiders players | Efficient in-game companion tool |
| API Provider | ardb.app | Data source (items, enemies, quests) |

---

## 5. Functional Requirements

### FR-1: Enemy Manifest

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-1.1 | Fetch enemy list from `GET /arc-enemies` | Must |
| FR-1.2 | Display each enemy with icon, name in a scrollable list | Must |
| FR-1.3 | Tap enemy row to navigate to detail view | Must |
| FR-1.4 | Detail view shows full description, weaknesses, and image | Must |
| FR-1.5 | Show loading indicator while fetching | Should |
| FR-1.6 | Show error state on network failure | Should |

### FR-2: Materials Manifest

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-2.1 | Fetch all items from `GET /items` and filter to material types | Must |
| FR-2.2 | Group materials by the quest that requires them | Must |
| FR-2.3 | Display a checkbox next to each material row | Must |
| FR-2.4 | Persist checkbox state in UserDefaults via `ChecklistStorageProtocol` | Must |
| FR-2.5 | Show quantity required per quest alongside each material | Should |
| FR-2.6 | Materials not linked to any quest shown in "General" section | Should |

### FR-3: Items Manifest

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-3.1 | Fetch all items from `GET /items` and filter to complex types (weapon, quick use, augment) | Must |
| FR-3.2 | Display item name, rarity badge, type, and icon | Must |
| FR-3.3 | Show `foundIn` locations for each item | Should |
| FR-3.4 | Show item value and description on tap (if available) | Could |

### FR-4: Navigation & Layout

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-4.1 | 3-tab segmented control at top: Enemies / Materials / Items | Must |
| FR-4.2 | Objectives is the default tab on the bottom "Objectives" navigation item | Must |
| FR-4.3 | All lists support pull-to-refresh | Should |

---

## 6. Non-Functional Requirements

| ID | Requirement | Category |
|----|-------------|----------|
| NFR-1 | App must render lists within 2s on a stable network | Performance |
| NFR-2 | Image cache must not exceed 100 MB on disk | Storage |
| NFR-3 | All interactive elements must have accessibility identifiers | Accessibility |
| NFR-4 | Support Dynamic Type for text scaling | Accessibility |
| NFR-5 | Minimum deployment target: iOS 16.7 | Compatibility |
| NFR-6 | Swift Strict Concurrency compliance (no data races) | Reliability |

---

## 7. Data Model Summary

| Entity | Source Endpoint | Key Fields |
|--------|----------------|------------|
| `Item` | `/items` | id, name, type, rarity, value, foundIn, icon |
| `ArcEnemy` | `/arc-enemies` | id, name, icon |
| `ArcEnemyDetail` | `/arc-enemies/{id}` | (extended enemy data) |
| `Quest` | `/quests` | id, title, requiredItems, trader, steps |
| `QuestMaterialGroup` | Derived locally | questTitle, materials (filtered items) |

---

## 8. UI/UX Guidelines

- **Color Palette:** Warm Yellow (primary CTAs), Magenta (alerts/tags), Cyan (borders/scanning), deep charcoal backgrounds
- **Typography:** Monospace data readouts for stats; bold headers for section titles
- **Imagery:** Cached remote icons with a fallback placeholder
- **Design Language:** Industrial terminal HUD — high contrast, grid textures, tactical feel

---

## 9. Assumptions & Constraints

| # | Assumption/Constraint |
|---|----------------------|
| 1 | The ardb.app API is publicly accessible without authentication |
| 2 | API responses follow a stable JSON schema |
| 3 | All item icons are served as static images from `https://ardb.app/static` |
| 4 | No write-back to the API is required (read-only companion) |
| 5 | Checklist state is device-local (no cross-device sync) |

---

## 10. Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| API schema changes without notice | Medium | High | Graceful decoding failures; optional fields |
| API downtime | Low | Medium | Show cached data or friendly error |
| Large item list causes scroll jank | Low | Medium | Lazy loading, image cache |

---

## 11. Acceptance Criteria

1. User can switch between Enemies, Materials, and Items tabs without data loss.
2. Enemy detail view loads and displays full information on tap.
3. Material checklist toggles persist after killing and relaunching the app.
4. Materials are grouped under their respective quest headings.
5. Complex items display rarity, type, and icon correctly.
6. All list views show loading and error states appropriately.
