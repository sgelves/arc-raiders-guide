# BRD-003: App Foundation — Splash, Navigation & Design System

## Document Information

| Field | Value |
|-------|-------|
| **Document ID** | BRD-003 |
| **Version** | 1.0 |
| **Date** | 2026-06-11 |
| **Author** | Sergio Gelves |
| **Status** | Draft |
| **App** | ArkRidersGuide (iOS) |

---

## 1. Executive Summary

This BRD covers the foundational layers of the ArkRidersGuide application: the splash/boot sequence, the global navigation architecture, the design system (colors, typography, spacing), and cross-cutting infrastructure (networking, image caching, accessibility). These components establish the visual identity, user flow, and technical backbone that all feature modules (Objectives Hub, Quests Hub) depend on.

---

## 2. Business Objectives

| # | Objective | Success Metric |
|---|-----------|---------------|
| BO-1 | Establish a memorable first impression with a themed boot sequence | Splash screen matches "ARC Tactical OS" terminal aesthetic |
| BO-2 | Provide intuitive navigation between app sections | Users find Quests/Objectives within 2 taps from any screen |
| BO-3 | Create a consistent, reusable design language | All screens share unified color palette, typography, and spacing |
| BO-4 | Build a reliable networking layer for all data features | API calls succeed, errors are handled, images are cached |
| BO-5 | Ensure accessibility compliance from day one | All elements have identifiers; VoiceOver navigable |

---

## 3. Scope

### 3.1 In Scope

- **Splash Screen** — animated boot/initialization sequence with branding
- **Main Tab Navigation** — persistent bottom tab bar (Objectives | Quests)
- **Design System** — color tokens, typography scale, spacing constants
- **Networking Layer** — `APIService` with protocol-based abstraction and error handling
- **Image Caching** — Kingfisher-based cached image loading component
- **Accessibility Infrastructure** — centralized accessibility identifiers

### 3.2 Out of Scope

- Feature-specific UI (covered in BRD-001 and BRD-002)
- Analytics / telemetry
- Crash reporting
- App Store listing and metadata
- Onboarding tutorial

---

## 4. Stakeholders

| Role | Name/Team | Interest |
|------|-----------|----------|
| Product Owner | Sergio Gelves | Architecture decisions, brand consistency |
| End Users | Arc Raiders players | Smooth, immersive experience |
| API Provider | ardb.app | Stable consumption of endpoints |

---

## 5. Functional Requirements

### FR-1: Splash Screen

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-1.1 | Display the ARC Tactical OS branding/logo on launch | Must |
| FR-1.2 | Show animated terminal boot sequence (text scrolling or scanline effect) | Should |
| FR-1.3 | Transition automatically to Main Tab View after boot completes | Must |
| FR-1.4 | Boot animation should complete within 2-3 seconds | Must |
| FR-1.5 | Display "Authorized Raider Only" or equivalent themed text | Should |
| FR-1.6 | Optional: "Initialize Shell" button for manual transition | Could |

### FR-2: Main Tab Navigation

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-2.1 | Persistent bottom tab bar with 2 tabs: Objectives and Quests | Must |
| FR-2.2 | Objectives tab is the default landing after splash | Must |
| FR-2.3 | Tab icons use SF Symbols consistent with the tactical theme | Must |
| FR-2.4 | Active tab indicated with primary (warm yellow) color | Must |
| FR-2.5 | Tab state preserved when switching between tabs | Must |
| FR-2.6 | Each tab maintains its own navigation stack | Must |

### FR-3: Design System

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-3.1 | Define primary color: Warm Yellow (interaction points, active nav) | Must |
| FR-3.2 | Define secondary color: Magenta (alerts, status tags) | Must |
| FR-3.3 | Define tertiary color: Cyan (borders, scanning effects) | Must |
| FR-3.4 | Define background colors: deep charcoals and textured blacks | Must |
| FR-3.5 | Define typography scale: headlines, body, caption, monospace data | Must |
| FR-3.6 | Define spacing constants: padding, card margins, list insets | Should |
| FR-3.7 | All design tokens stored in centralized `DesignSystem.swift` utility | Must |
| FR-3.8 | Colors defined as SwiftUI `Color` extensions or constants | Must |

### FR-4: Networking Layer

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-4.1 | `APIServiceProtocol` defines all network methods | Must |
| FR-4.2 | `APIService` implements protocol using async/await (no Combine) | Must |
| FR-4.3 | Base URL for data: `https://ardb.app/api` | Must |
| FR-4.4 | Base URL for images: `https://ardb.app/static` | Must |
| FR-4.5 | Support endpoints: `/items`, `/arc-enemies`, `/arc-enemies/{id}`, `/quests` | Must |
| FR-4.6 | Return typed errors (`APIError`) for invalid responses | Must |
| FR-4.7 | `MockAPIService` available for testing and previews | Must |
| FR-4.8 | TDD approach: network layer developed test-first | Must |

### FR-5: Image Caching

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-5.1 | Reusable `CachedImageView` component for all remote images | Must |
| FR-5.2 | Uses Kingfisher library (installed via SPM) | Must |
| FR-5.3 | Cache key is the entity `id` | Must |
| FR-5.4 | Image URLs constructed from `imageBaseURL + relativePath` | Must |
| FR-5.5 | Show placeholder while loading | Should |
| FR-5.6 | Show fallback icon on failure | Should |

### FR-6: Accessibility

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-6.1 | Centralized `AccessibilityIdentifiers` enum for all UI elements | Must |
| FR-6.2 | Identifiers assigned to: titles, images, cells, lists, buttons, nav bars | Must |
| FR-6.3 | All identifiers follow a consistent naming pattern | Must |
| FR-6.4 | Support VoiceOver navigation order | Should |
| FR-6.5 | Support Dynamic Type | Should |

---

## 6. Non-Functional Requirements

| ID | Requirement | Category |
|----|-------------|----------|
| NFR-1 | App launches to interactive state within 3s on iPhone 12+ | Performance |
| NFR-2 | Network requests timeout after 30s with appropriate error | Reliability |
| NFR-3 | Image cache disk usage capped at 100 MB | Storage |
| NFR-4 | Strict Swift Concurrency — no data races | Reliability |
| NFR-5 | iOS 16.7 minimum deployment target | Compatibility |
| NFR-6 | Universal app: iPhone and iPad | Compatibility |
| NFR-7 | All ViewModels testable via protocol injection | Testability |
| NFR-8 | No force-unwrapped optionals in production code | Code Quality |

---

## 7. Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                   App Entry                      │
│            ArkRidersGuideApp.swift               │
│              (@main, WindowGroup)                │
└──────────────────────┬──────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────┐
│               Splash Screen                      │
│          SplashView + SplashVM                   │
└──────────────────────┬──────────────────────────┘
                       │ (auto-transition)
                       ▼
┌─────────────────────────────────────────────────┐
│              Main Tab View                       │
│         TabView (Objectives | Quests)            │
├────────────────────┬────────────────────────────┤
│   Objectives Tab   │       Quests Tab           │
│  ┌──────────────┐  │  ┌──────────────────────┐  │
│  │ Enemies List │  │  │   Quest List          │  │
│  │ Materials    │  │  │   Quest Detail        │  │
│  │ Items List   │  │  │                       │  │
│  └──────────────┘  │  └──────────────────────┘  │
└────────────────────┴────────────────────────────┘

┌─────────────────────────────────────────────────┐
│              Services Layer                       │
│  APIServiceProtocol → APIService                 │
│  ChecklistStorageProtocol → UserDefaultsStorage  │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│              Shared Components                    │
│  CachedImageView | DesignSystem | Constants      │
│  AccessibilityIdentifiers                        │
└─────────────────────────────────────────────────┘
```

---

## 8. Design System Specification

### 8.1 Color Palette

| Token | Usage | Hex (Approx) |
|-------|-------|-------------|
| Primary (Warm Yellow) | CTAs, active tabs, branding highlights | `#F5A623` |
| Secondary (Magenta) | Alerts, status tags, high-priority indicators | `#E91E63` |
| Tertiary (Cyan) | Borders, scan effects, secondary data | `#00BCD4` |
| Background Primary | Main backgrounds | `#1A1A1A` |
| Background Secondary | Cards, elevated surfaces | `#2D2D2D` |
| Text Primary | Headings, primary labels | `#FFFFFF` |
| Text Secondary | Descriptions, metadata | `#B0B0B0` |

### 8.2 Typography

| Style | Usage | Spec |
|-------|-------|------|
| Headline | Screen titles, section headers | Bold, 20-24pt |
| Body | Descriptions, list labels | Regular, 16pt |
| Caption | Metadata, tags, secondary info | Regular, 12-14pt |
| Monospace | Data readouts, stats, IDs | JetBrains Mono / system monospace, 14pt |

### 8.3 Spacing

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4pt | Inline spacing |
| sm | 8pt | Component internal padding |
| md | 16pt | Card padding, list insets |
| lg | 24pt | Section spacing |
| xl | 32pt | Screen margins |

---

## 9. Technical Constraints

| # | Constraint |
|---|-----------|
| 1 | SwiftUI only — no UIKit wrappers unless absolutely necessary |
| 2 | Async/await for all asynchronous work — no Combine publishers for network calls |
| 3 | ViewModels use `ObservableObject` + `@Published` (import Combine, not SwiftUI) |
| 4 | Protocol-oriented design: all services behind protocols for testability |
| 5 | Dependency injection through constructors for ViewModels |
| 6 | File-system-synchronized Xcode groups — no manual build phase management |
| 7 | Kingfisher via SPM for image caching |
| 8 | Strict concurrency: `MainActor` isolation by default |

---

## 10. Assumptions & Constraints

| # | Assumption/Constraint |
|---|----------------------|
| 1 | The ardb.app API requires no authentication |
| 2 | The app is a read-only companion (no data mutation) |
| 3 | No backend infrastructure to maintain — relies entirely on ardb.app |
| 4 | Single developer project — no team coordination overhead |
| 5 | Design assets (colors, fonts) are self-defined, not provided by a third party |

---

## 11. Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| ardb.app API goes offline permanently | Low | Critical | Consider local JSON fallback bundle |
| Kingfisher SPM dependency breaks on Xcode update | Low | Medium | Pin to stable version; have fallback AsyncImage |
| Design system drifts across features | Medium | Low | Centralize all tokens in DesignSystem.swift |
| Splash animation causes launch-time rejection by Apple | Low | Medium | Keep animation under 3s; no blocking network calls |

---

## 12. Dependencies

| Dependency | Type | Purpose |
|------------|------|---------|
| Kingfisher | SPM Package | Image downloading and caching |
| ardb.app API | External Service | All game data (items, enemies, quests) |
| SF Symbols | System | Iconography |
| iOS 16.7+ SDK | Platform | Minimum deployment target |

---

## 13. Acceptance Criteria

1. App launches and shows a themed splash screen before navigating to main content.
2. Bottom tab bar displays Objectives and Quests tabs with correct icons and colors.
3. Switching tabs preserves each tab's navigation state.
4. Design system colors and typography are consistently applied across all screens.
5. All API calls use `APIServiceProtocol` and can be mocked for unit tests.
6. `CachedImageView` loads and caches remote images using Kingfisher.
7. All tappable UI elements have accessibility identifiers from the centralized enum.
8. App builds and runs on iPhone and iPad simulators targeting iOS 16.7.
9. No force-unwrapped optionals in production Swift files (except URL literals in Constants).
10. ViewModels are fully testable with injected mock services.
