# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ArkRidersGuide is a SwiftUI iOS app (iPhone and iPad). It is in early development — currently just the default Xcode template.

## Build & Run

Build via Xcode using the **ArkRidersGuide** scheme, or from Claude Code using the `BuildProject` tool. There are no test targets yet.

## Architecture

- **UI framework:** SwiftUI
- **App entry point:** `ArkRidersGuideApp.swift` (`@main`, single `WindowGroup`)
- **Project structure:** Uses Xcode's file-system-synchronized groups — files added to the `ArkRidersGuide/` directory are automatically included in the build.

## Build Configuration

- **Targets:** iOS only (`iphoneos`, `iphonesimulator`). No macCatalyst.
- **Deployment target:** iOS 16.7
- **Swift concurrency:** Strict — `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` and `SWIFT_APPROACHABLE_CONCURRENCY = YES` are enabled. All types are implicitly `@MainActor` unless opted out with `nonisolated`.
- **Bundle ID:** `sgelves.ArkRidersGuide`

## Coding conventions

- Each view is inside a folder where Views ends with View word, ViewModels with VM, and Network models with Service.
- Classes names are written in PascalCase, variables names in camelCase, and assets in snake_case
- Never force-unwrap optionals, always use weak self inside closures and then unwrap self.
- Always use `async/await` instead of Combine for async work
- ViewModels must always `import Combine` (for `ObservableObject`/`@Published`) and never `import SwiftUI`
- Use SF Symbols for icons
- use TDD to develop network layer, map all fields using Codable (Encodable & Decodable)
- use TDD to develop ViewModels.
- use protocol oriented programming, and dependency injection inside classes' attributes through a setupMethod in view, 
for VM use dependency injection through constructors.
- create a Doubles, and mocks with lorem ipsum data to inject them in UI integration test.
- include UI accesibility identifiers for components like title, image, cell, list, buttons, any navigation bars.
- create a UI integration test with all the view components with ccesibility identifiers, inject the doubles or mocks, then
check the view is working correctly.

## Network layer 

The base url for data is ´https://ardb.app/api´, and for images it is ´https://ardb.app/static´. 

1. Screen ID: 29e2e79a5d4b42eebf37924dad21d47b will use the data inside url_base + relative url ´/items´, but this one is for
complex items like weapons, usables, or augments

2. Screen ID: ad22ea852daa481bb57fda38b06f14a1 will use the data inside url_base + relative url ´/arc-enemies´

3. Screen ID: 543daa1e154645308f365dec152540cc will use the data inside url_base + relative url ´/quests´

4. Screen ID: 347cc0d3486f472887774f5a1ef727b3 will use the data inside url_base + relative url ´/items´, this category excludes
all items listed in numeral 1 from this list.

5. All images are loaded using the "image" or "icon" if first do not exist. Build the urls with relative url + its preceding base that is different for images.
Images use a cache mechanism with kingfisher library installed with spm, the library of the cache corresponds to the ´id´ of the JSON object.

6. Design system font, and colors are gonna be stored in files, and utility classes inside a folder called utils.

## Stitch Instructions

Get the images and code for the following Stitch project's screens:

## Project
Title: Arc Riders Progress Tracker
ID: 3592321849921961946

## Screens:
1. Objectives - Items (Triad HUD)
    ID: 29e2e79a5d4b42eebf37924dad21d47b

2. Objectives - Enemies (Triad HUD)
    ID: ad22ea852daa481bb57fda38b06f14a1

3. Quests - Followed & Available (Triad HUD)
    ID: 543daa1e154645308f365dec152540cc

4. Splash Screen (Triad HUD)
    ID: 7f67cb6d42d74dd1a7db65b0c8d2d74a

5. Objectives - Materials (Triad HUD)
    ID: 347cc0d3486f472887774f5a1ef727b3

6. Design System
    ID: asset-stub-assets-130342db623041d79310b3ed4eaa0608-1779314859908

Use a utility like `curl -L` to download the hosted URLs.

### Project Brief: ARC_TACTICAL_OS // Companion Interface

#### 1. Vision & Core Objective
ARC_TACTICAL_OS is a high-fidelity tactical companion application designed for the "Arc Raiders" universe. The interface serves as a gritty, "Authorized Raider Only" terminal that provides real-time field intelligence, objective tracking, and inventory management for scavenging operations.

#### 2. Design Philosophy
- **Aesthetic:** Industrial Scavenger HUD. High-contrast data readouts, scanline effects, and tactile "lo-fi" digital textures.
- **Visual Identity (Triad HUD):**
    - **Primary (Warm Yellow):** Interaction points, active navigation, and critical branding.
    - **Secondary (Magenta):** Tactical alerts, quest status, and high-priority tags.
    - **Tertiary (Cyan):** Scanning effects, secondary data, and UI borders.
    - **Background:** Deep charcoals and textured blacks to maintain terminal immersion.

#### 3. Application Architecture & User Flow
The application follows a structured boot-to-operation flow:
1.  **Entry Layer (Splash):** System initialization and encrypted boot sequence.
2.  **Primary HUD (Objectives):** The default landing state, focused on **Threat Assessment (Enemies)**.
3.  **Lateral Manifests:** Sub-navigation within Objectives for **Materials** and **Items** salvage tracking.
4.  **Strategic Layer (Quests):** Broad mission oversight, separating followed operations from available field intel.

#### 4. Key Functional Modules
##### A. Splash & Authorization
- Animated boot sequence with terminal log stream.
- Branding integration with the "Arc Raiders" logo.
- Interactive "Initialize Shell" gateway.

##### B. Objectives Hub (Integrated Tracking)
- **Enemy Manifest:** Level-gated threat identification, tracking links, and weakness assessment.
- **Materials Manifest:** Quest-specific salvage objectives vs. general field scrap.
- **Item Manifest:** Cargo volume tracking, quest-linked weaponry, and scrap analysis tools.
- **Universal Top Nav:** Fixed 3-tab switcher (Enemies, Materials, Items).

##### C. Quests Hub
- **Followed Operations:** High-visibility cards for active missions.
- **Available Intel:** Lower-priority feed for discoverable opportunities in the field.
- **Status Tagging:** "Urgent," "Sector-specific," and "Followed" metadata.

##### D. Tactical Dashboard (Global)
- Operator identity verification.
- Power cell stability monitors.
- Quick-glance summaries for Items, Quests, and Threat Intel.

#### 5. Technical Specifications
- **Device Target:** Mobile (Responsive for Tablet/Desktop scaling).
- **Navigation:** Persistent two-tab bottom bar (Quests | Objectives).
- **Styling:** Tailwind CSS with custom industrial utilities (chamfer-clip, scanlines, grid-backgrounds).
- **Typography:** Sora (Headlines) and JetBrains Mono (Tactical Data).

