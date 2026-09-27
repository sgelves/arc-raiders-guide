# BRD-002: Quests Hub — Mission Tracking & Strategic Overview

## Document Information

| Field | Value |
|-------|-------|
| **Document ID** | BRD-002 |
| **Version** | 1.0 |
| **Date** | 2026-06-11 |
| **Author** | Sergio Gelves |
| **Status** | Draft |
| **App** | ArkRidersGuide (iOS) |

---

## 1. Executive Summary

The Quests Hub provides Arc Raiders players with a strategic overview of all available missions and their progress. It separates active "followed" operations from available field intel, displays quest details including steps, required items, trader info, and map locations. This module serves as the mission-planning layer of the companion app, enabling players to prepare gear and materials before entering the field.

---

## 2. Business Objectives

| # | Objective | Success Metric |
|---|-----------|---------------|
| BO-1 | Centralize quest information so players don't need external wikis | All quests from API displayed with full detail |
| BO-2 | Help players prepare required items before starting a quest | Required items list visible per quest with quantities |
| BO-3 | Allow players to distinguish active vs. available missions | Clear visual separation between followed and available quests |
| BO-4 | Surface trader and map context for each quest | Trader image/name and map names visible on quest cards |

---

## 3. Scope

### 3.1 In Scope

- **Quest List View** — scrollable feed of all quests from the API
- **Quest Cards** — summary cards showing title, trader, XP reward, and status tags
- **Quest Detail View** — expanded view with steps, required items, map info, and trader details
- **Required Items Display** — list of items with quantities needed per quest
- **Trader Information** — trader name and image displayed on quest cards and detail
- **Map Context** — which maps a quest is available on
- **Bottom Tab Navigation** — Quests tab alongside Objectives tab

### 3.2 Out of Scope

- Quest completion tracking / progress persistence (future feature)
- Follow/unfollow quest functionality (future feature)
- Quest filtering by map or trader
- Quest search
- Notifications for new quests

---

## 4. Stakeholders

| Role | Name/Team | Interest |
|------|-----------|----------|
| Product Owner | Sergio Gelves | Feature direction, acceptance criteria |
| End Users | Arc Raiders players | Mission planning and preparation |
| API Provider | ardb.app | Quest data source |

---

## 5. Functional Requirements

### FR-1: Quest List

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-1.1 | Fetch all quests from `GET /quests` | Must |
| FR-1.2 | Display quests as cards in a scrollable list | Must |
| FR-1.3 | Each card shows: quest title, trader name, trader image, XP reward | Must |
| FR-1.4 | Show map names associated with each quest | Should |
| FR-1.5 | Show loading skeleton while fetching | Should |
| FR-1.6 | Show error state with retry action on failure | Should |

### FR-2: Quest Detail View

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-2.1 | Navigate to detail view on quest card tap | Must |
| FR-2.2 | Display quest title and full description | Must |
| FR-2.3 | List all quest steps with title and amount (if applicable) | Must |
| FR-2.4 | List all required items with name, icon, and quantity | Must |
| FR-2.5 | Display trader section with name, image, and description | Must |
| FR-2.6 | Display associated maps | Should |
| FR-2.7 | Show XP reward prominently | Should |

### FR-3: Quest Card Component

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-3.1 | Card must show trader icon/image on the left | Must |
| FR-3.2 | Card must show quest title as primary text | Must |
| FR-3.3 | Card should show XP reward as a badge or secondary label | Should |
| FR-3.4 | Card should indicate number of required items | Could |
| FR-3.5 | Cards are tappable with navigation feedback | Must |

### FR-4: Navigation

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-4.1 | Quests accessible via bottom tab bar (second tab) | Must |
| FR-4.2 | Navigation stack for quest list → quest detail | Must |
| FR-4.3 | Back navigation from detail to list | Must |

---

## 6. Non-Functional Requirements

| ID | Requirement | Category |
|----|-------------|----------|
| NFR-1 | Quest list renders within 2s on stable network | Performance |
| NFR-2 | Smooth scrolling at 60fps with image-heavy cards | Performance |
| NFR-3 | All interactive elements have accessibility identifiers | Accessibility |
| NFR-4 | Quest detail supports VoiceOver reading order | Accessibility |
| NFR-5 | Minimum deployment target: iOS 16.7 | Compatibility |
| NFR-6 | Works on iPhone SE (small screen) through iPad Pro | Compatibility |

---

## 7. Data Model

| Entity | Source | Key Fields |
|--------|--------|------------|
| `Quest` | `GET /quests` | id, title, description, trader, maps, steps, requiredItems, xpReward |
| `QuestMap` | Nested in Quest | id, name |
| `QuestStep` | Nested in Quest | title, amount |
| `Trader` | Nested in Quest | id, name, description, image, icon, type |
| `RequiredItem` | Nested in Quest | item (Item), amount |
| `Item` | Referenced by RequiredItem | id, name, icon, type, rarity |

---

## 8. UI/UX Guidelines

- **Quest Cards:** Dark charcoal card with subtle border (cyan accent), trader image on leading edge, yellow title text
- **Detail View:** Full-bleed header with quest title, sectioned content (Steps, Required Items, Trader, Maps)
- **Status Tags:** Magenta badges for urgency/priority indicators (future: "Urgent", "Followed")
- **Layout:** Vertical scrolling list; detail uses a vertical form-style layout
- **Imagery:** Trader images cached via Kingfisher; fallback to SF Symbol placeholder

---

## 9. User Stories

| ID | Story | Acceptance Criteria |
|----|-------|-------------------|
| US-1 | As a player, I want to see all available quests so I can decide which to pursue | Quest list loads and shows all quests from API |
| US-2 | As a player, I want to see what items a quest requires so I can prepare | Tapping a quest shows required items with quantities |
| US-3 | As a player, I want to know which trader offers a quest | Trader name and image visible on card and detail |
| US-4 | As a player, I want to see quest steps so I know what to do | Steps listed in order on detail view |
| US-5 | As a player, I want to know the XP reward so I can prioritize | XP displayed on card and detail view |

---

## 10. Assumptions & Constraints

| # | Assumption/Constraint |
|---|----------------------|
| 1 | All quest data is available via a single `GET /quests` endpoint |
| 2 | Trader images use the same `https://ardb.app/static` base URL |
| 3 | Quest steps are displayed in the order returned by the API |
| 4 | No write operations — the app is read-only |
| 5 | "Followed" vs "Available" separation is a future feature requiring local persistence |

---

## 11. Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Large number of quests causes slow initial load | Medium | Medium | Paginate or lazy-load; show skeleton UI |
| Required items reference items not yet in local cache | Low | Low | Fetch items independently; show name even without icon |
| Trader images missing from API | Low | Low | Fallback placeholder icon |

---

## 12. Future Considerations

- **Follow/Unfollow:** Allow users to mark quests as "followed" with local persistence
- **Quest Progress:** Track step completion with checkboxes
- **Filtering:** Filter quests by map, trader, or XP range
- **Search:** Full-text search across quest titles and descriptions
- **Notifications:** Alert players when new quests are added to the API

---

## 13. Acceptance Criteria

1. All quests from the API are displayed in the list view.
2. Tapping a quest navigates to a detail view with all relevant information.
3. Required items show item name, icon, and quantity needed.
4. Trader information (name + image) is visible on quest cards.
5. Quest steps are listed in order with amounts where applicable.
6. Loading and error states are handled gracefully.
7. Navigation between Quests tab and Objectives tab works without data loss.
