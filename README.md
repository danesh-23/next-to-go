# 🏇 Next To Go – Entain Technical Task (2025)

A Swift 6-powered race tracking application that displays the next upcoming 5 races from selected categories (Horse, Greyhound, Harness), using clean architecture principles, offline caching, strict concurrency, accessibility enhancements, animations, and robust testing with code styling and consistency enforced.

---

## 🚀 Getting Started

1. Clone the project
2. Open in **Xcode 16+**
3. Make sure you're running Swift 6 on Xcode as this app is fully built on Swift 6.
4. Build and run on iOS Simulator or device
5. Run all tests by going to **Product->Test** or hitting **CMD+U**

## ✅ Features Implemented

- Always see 5 races depending on category selected.
- All races can go up to 1 min past the start before disappearing
- Filter UI for categories with live toggling
- Pull-to-refresh integration
- Smooth UI animations and responsive layout
- Accessibility support (VoiceOver + Voice Control +Dynamic Text)
- Offline caching using **SwiftData** with graceful fallback(Optional)


---

## 🏗️ Architecture

The app uses **Clean Architecture** layered as follows:

### 1. **Domain Layer**
- `GetNextRacesUseCase`: Central logic to:
  - Retain valid races for 60 seconds past their start
  - Top-up new races (without duplicates)
  - Retry fetching with larger batch sizes if underfilled
  - Respond to filter changes dynamically
- `Models`: Holds DTO for object types from the endpoint
- `Repositories Interface`: Holds the interfaces defined for the repositories that the use case can use.

### 2. **Data Layer**
- `RaceRepositoryImpl`: Acts as the bridge between API and cache.
- `NedsAPIClient`: Fetches from remote Neds API.
- `RaceCacheRepositoryImpl`: Stores and loads races locally using SwiftData.
- All repositories use **protocol-first abstraction** for easy mocking & substitution.

### 3. **Presentation Layer**
- `RaceListViewModel`: Manages state, triggers refreshes, and handles filter toggling.
- `RaceListView`: The SwiftUI screen rendering races and filters.
- UI components like `RaceRowView` and `CategoryFilterView` and `CountdownView` are reusable and decoupled.

---

## 💡 Key Technical Decisions

| Decision | Rationale |
|---------|-----------|
| Used Strict concurrency throughout the app | Using async/await improves readability, reduces deeply nested closures, and eliminates common race conditions(with Swift 6 strict concurrency enabled). Adopting MainActor isolation for UI-related classes like RaceListViewModel ensures safe UI updates and all calls to async methods (e.g. repository/use case operations) are wrapped safely with await, and Task is used explicitly to prevent suspension or cancellation issues in view logic.|
| Adopted CLEAN architecture with MVVM in presentation layer | Ensures clear separation of concerns and followed SOLID principles as much as possible by ensuring each component served a single purpose and making them as open to extension and available to be substituted with abstractions(interfaces). Broken in Domain, Data and Presentation layers and while this is a small and very simple app, it still lent itself well as use case and business logic is very cleanly separated from the fetching of data as well as the presentation of this and handling user interactions - ofcourse this typically does go farther by going into the respective data source layers and or having separate service layers communicating with the respository but decided that's overkill for this. |
| Increasing batch size for fetch count when less than 5 races are available | Due to lack of details/specifications around endpoint behaviour, it was assumed that the endpoint functioned ona time-based response so responses would be the same until the first non-eligible race was invalid(past start time validity) and so to ensure we get new responses; increased the count size so we can get new responses since no offset/pagination was available. This is up to a self-imposed limit of a 100 items just to show that if we are going this far back, we might want to consider more efficient methods |
| Implement unit testing using SwiftTesting | Testing was implemented using Swift Testing, covering both the RaceListViewModel and GetNextRacesUseCase. The ViewModel tests validate UI-related state transitions such as loading, error handling, and category filtering, while the use case tests rigorously check business logic including filtering, expiry validation, deduplication, and fallback fetching behavior. By decoupling components via protocol abstractions and mocking dependencies, this allows us to easily swap in one implmentation for another also fulfilling part of SOLID.<br>We have achieved coverage of over 90% for both of these and in reality could benefit from mocking and testing farther layers below by also creating spies for native components like swiftdata etc but obvioulsy once again witht time constraint this was foregone afeguards against regressions, reduces time-to-confidence for new features, and enables robust, iterative development in parallel streams. |
| Implemented accessibility support | Uses accessibility labels so the app is fully usable with custom labels depending on the component and supports voiceover as well as voice control off the bat, this would also technically allow us to leverage UI testing more easily but due to lack of time, this was deemed unnecessary. |
| Using SwiftFormat and SwiftLint | SwiftFormat and SwiftLint were integrated to enforce consistent code style and proactively catch code quality issues across the entire codebase, ensuring long-term maintainability and team-wide alignment. We used AirBnb's linting and formatting styles loosely as I have modified some to suit the team better(just me) which is also to highlight, theres no hard and fast rules, theres best practices but they're mostly guidelines to adjust for your team. By automating formatting and static analysis, they also reduce cognitive overhead, accelerate onboarding, and allow reviewers to focus on architecture and logic rather than superficial style concerns — practices widely adopted in large-scale engineering teams to support scalable development and CI enforcement.|
| Error propogation and handling | We use thrown errors across the app as throwing errors allow for it to be propogated to the desired level to be handled. All issues in the networking and repository and use case are propogated to the surface to be handled in the viewmodel and currently it just sets slightly different error messages which is immediately shown to the user and this handles failed decoding or networking issues due to lost connection etc. and in an ideal scenario, we would cast the thrown errors and handle them by displaying more useful error messages depending on the scenario since this provides a much better UX but I have decided to document this rather than implement it. | 
| SwiftData for offline caching | Offline caching was introduced via a local data layer (RaceCacheRepositoryImpl) implemented using SwiftData, and integrated at the repository layer (RaceRepositoryImpl). This is a very simple caching layer as it's just a fun addition to demonstrate SwiftData integration and has not been passed all integration tests as due to lack of time, syncing with filtering logic as well as implement testing was skipped. This feature is also not enabled by default and can be added in by instructions to uncomment a line in the respository layer (RaceRepositoryImpl).|

---

## 🧪 Testing Strategy (Swift Testing Framework)

### ✅ ViewModel Tests (`RaceListViewModelTests`)
- Race fetch populates view model correctly
- Error message is set if fetch fails
- Filter toggling updates category set and triggers reload
- `autoRefreshTask` is cancelled when ViewModel is deallocated (using `deinit` behavior)

### ✅ Use Case Tests (`GetNextRacesUseCaseTests`)
Covers all major scenarios:
- Filters by category
- Excludes expired races
- Preserves currently valid races
- Adds top-up races as needed
- Avoids duplicates
- Retries fetching with increased batch size if < 5
- Handles changes to selected categories gracefully

#### 🧪 Test Techniques Used:
- `#expect()` assertions from Swift Testing
- Custom `MockRepository` with `backupStubs` support and `MockGetNextRacesUseCase`
- Custom stub data (`Race.stub(...)`)
- Asynchronous testing with `await` and structured tasks
- Polling strategies for ViewModel where needed

---

## 🧹 Code Style & Quality

### ✅ SwiftFormat

Configured with best-practice rules including:
- Enforced line wrapping at 130 characters with:
  ```bash
  --maxwidth 130
  --wraparguments beforefirst
  --wrapcollections beforefirst
  ```
- Ensures clarity on multiline function calls and array literals
- Prevents visual clutter and promotes team consistency

### ✅ SwiftLint

Configured with best-practice rules including:
- `force_cast` and `force_try` disallowed
- Required access control (`private` / `fileprivate`)
- Type body length & cyclomatic complexity warnings

---

## 🧠 Accessibility & UX

- All toggleable filters have `accessibilityLabel`
- VoiceOver and Voice Control both supported by design
- Animations added for all list changes and filter updates via `.withAnimation`
- UI is responsive and styled with dynamic SwiftUI layouts

---

## 🗂️ Offline Caching (SwiftData)

- Cached up to 10 races from API
- On API failure, loads from SwiftData-backed `RaceEntity` store (if enabled)
- Automatically prunes cache on save to keep consistent
- Fully actor-isolated for concurrency safety

---

## 🧩 Requirements Not Yet Implemented (Time Constraint)

- Deep linking or navigation into race details
- Custom accessibility actions
- Full data caching layer
- *Those mentioned in technical decisions above*

---

## 🧾 Summary

This app showcases full-stack Swift 6 best practices, real-world architecture separation, robust error handling, testing with real mocks and structured concurrency, enforcing code style and consistency, a backup cache layer for persistent storage and an overall high-quality SwiftUI user experience.
