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
