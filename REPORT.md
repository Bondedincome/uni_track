# UniTrack — Changes Summary

This report summarizes the changes I made to finish and improve the project, add a robust storage strategy, and prepare the app for Android.

## What I changed

- Fixed `Course` model JSON serialization (use `color.value` instead of a non-existent method).
- Introduced a storage abstraction: `lib/shared/services/storage_adapter.dart`.
  - Prefers Hive (fast, local NoSQL) via `hive_flutter` when available.
  - Falls back to `SharedPreferences` if Hive initialization fails.
  - Supports migrating existing data from `SharedPreferences` into Hive on first access.
- Refactored `DatabaseService` to use the new `StorageAdapter` and to perform safe migration.
- Initialized storage at app startup in `lib/main.dart` (`StorageAdapter.init()` is awaited before `runApp`).
- Updated `pubspec.yaml` with new dependencies: `hive`, `hive_flutter`, `path_provider`, `sqflite` (optional relational option).

## Files added/modified

- Modified: `lib/features/courses/models/course.dart` — fixed `toJson()`.
- Modified: `lib/shared/services/database_service.dart` — storage refactor and migration.
- Added: `lib/shared/services/storage_adapter.dart` — storage abstraction with Hive fallback.
- Modified: `lib/main.dart` — initialize storage before app start.
- Modified: `pubspec.yaml` — added storage dependencies.
- Added: `REPORT.md` (this file).

## Storage choice and reasoning

- Default: Hive (via `hive_flutter`) for local, performant, offline-first storage. It stores structured data, is fast, supports boxes, and is well-suited for mobile apps.
- Fallback: `SharedPreferences` for very small datasets or when Hive can't initialize.
- Optional: `sqflite` is included for scenarios that require a relational database and complex queries. I did not convert the data model to SQL in this pass, but adding an adapter is straightforward.

This combination allows the app to handle almost any storage need: simple preferences, fast local document store, or full SQL relational DB.

## Next recommended steps (optional)

- Add a settings screen to let the user choose storage (Hive vs. SQLite) and to force migrations.
- Add Hive TypeAdapters for strongly-typed storage of `Course`, `Assignment`, and `GradeRecord` (avoids JSON encode/decode overhead).
- Add tests and run `flutter build apk` on an Android emulator or device to validate the final APK.
- Consider implementing cloud sync (e.g., Firebase or custom backend) to support cross-device synchronization.

If you want, I can:

- Implement a settings UI to pick storage and trigger migrations.
- Add Hive TypeAdapters and migrate the models to typed Hive storage.
- Run a local build and provide the APK.

---
If you'd like me to continue, tell me which of the optional next steps you want prioritized.
