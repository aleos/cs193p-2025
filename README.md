# CS193p Spring 2025

Following Stanford's [Developing Applications for iOS using SwiftUI](https://cs193p.stanford.edu), building a code-breaking game step by step across lectures and assignments.

<!-- TODO: Add a gameplay GIF once the course is complete -->

## The Game

A Mastermind-style game where you guess a hidden code through deduction. Each attempt reveals which pieces are correct, misplaced, or wrong — narrowing things down until you crack it.

The workspace has two variants:

- **CodeBreaker** — the original, with colored emoji pegs, six themes, and adjustable code length
- **CodeWordBreaker** — a word-guessing spin-off with a QWERTY keyboard, per-key match hints, and dictionary validation

Both share the same core: match markers, elapsed time, animations, and 3–6 element codes.

Built with SwiftUI, SwiftData, and Swift concurrency. Multi-platform (iPhone, iPad, Mac), with custom animations throughout.

## What's Covered

**Core Concepts**
- Model-view separation, Swift type system, generics
- Data flow with `@State`, `@Binding`, `@Environment`
- `@Observable` and `@Model` for state management
- Protocol-oriented design, `Hashable` / `Identifiable` conformance
- Swift concurrency with `async`/`await` and multithreading

**Frameworks & Patterns**
- SwiftUI with adaptive layout across iPhone, iPad, and Mac
- SwiftData for persistence, `@Query`, `#Predicate`-based search and filtering
- `NavigationSplitView` for multi-platform navigation
- Custom animations: matched geometry effects, `GeometryEffect`, view transitions
- Custom QWERTY keyboard layout
- Sheets, forms, and user settings

## Requirements

Xcode 26+, iOS 26+, Swift 6.2+

<details>
<summary>Lectures and assignments</summary>

### Lectures
1. Getting Started with SwiftUI
2. More SwiftUI Basics
3. Model and UI; Swift Type System
4. Building CodeBreaker's Model
5. Layout; Data Flow
6. Data Flow Demonstration
7. Generics and Views; Animation
8. Animation Demonstration
9. Elapsed Time; Protocols
10. List and Navigation
11. iPad; Sheets
12. CodeBreaker Editor
13. SwiftData
14. More SwiftData
15. Yet More SwiftData; Multithreading
16. Final Project Miscellany

### Assignments
1. **MatchMarkers** — Prototype the match indicator UI component
2. **CodeBreaker** — Add game logic, themes, and configurable peg count
3. **CodeWord Breaker** — Build a word-guessing variant with a QWERTY keyboard
4. **CodeWord Breaker History** — Game history list, navigation, multi-platform, and settings
5. **Persistent History** — Persist games with SwiftData, add search and filtering

</details>
