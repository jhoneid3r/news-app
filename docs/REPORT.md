# NewsFlow — Technical Report

## Overview

NewsFlow is a cross-platform news reader built with Flutter, following **Clean Architecture** principles, **BLoC** for state management, and **Firebase** as the backend.

---

## 1. Backend

### Schema Design

The schema was designed around a single `articles` Firestore collection with the following considerations:

- **Flat structure** rather than sub-collections, because all query patterns (by category, by date, breaking news) only require one collection level.
- **`thumbnailURL` as a download URL** pointing to Firebase Cloud Storage (`media/articles/{id}.jpg`), avoiding extra Storage SDK calls on every list item.
- **`tags` array** field enabling `array-contains` queries for keyword filtering.
- **`isBreaking` boolean** for efficient breaking-news queries without a separate collection.
- **`views` counter** on the document for read counts (with a note to use distributed counters at scale).

Full schema: `backend/docs/DB_SCHEMA.md`

### Firestore Rules

Rules enforce:
1. **Public read** on `articles` and `categories` — no authentication required to browse news.
2. **Authenticated write** on `articles` / `categories` — in production, this would be further restricted to an `admin` custom claim.
3. **User-scoped read/write** on `/users/{userId}/bookmarks` — users can only access their own data.

### Storage

Thumbnails live at `media/articles/{articleId}.jpg`. The download URL is stored in Firestore so clients never need to make an extra Storage call per list item.

---

## 2. Frontend Architecture

### Clean Architecture Layers

```
lib/
  core/               ← Shared infrastructure (theme, DI, router, utils)
  features/
    news/
      domain/         ← Entities, repository interfaces, use cases
      data/           ← Models, data sources (mock + Firestore), repository impl
      presentation/   ← BLoC/Cubit, pages, widgets
    bookmarks/
      domain/
      data/
      presentation/
```

**Dependency rule:** outer layers depend on inner layers; inner layers never import from outer ones. The domain layer has zero Flutter/Firebase dependencies.

### State Management — BLoC

| BLoC / Cubit | Responsibility |
|---|---|
| `NewsFeedBloc` | Feeds home page: top headlines, breaking news, category filtering |
| `ArticleDetailCubit` | Loads and exposes a single article |
| `SearchBloc` | Real-time article search |
| `BookmarksCubit` | Bookmark CRUD, persisted via `shared_preferences` |

Events and states are `Equatable` to prevent redundant rebuilds.

### Dependency Injection

`GetIt` is used as the service locator. All dependencies are registered in `lib/core/di/injection_container.dart`. BLoCs are registered as **factories** (new instance per page) while repositories and data sources are **singletons**.

### Navigation

`go_router` with a `ShellRoute` provides:
- Persistent bottom navigation bar (Home / Saved).
- Deep-linkable routes: `/`, `/bookmarks`, `/search`, `/article/:id`.
- Route-level `extra` parameter to pass an already-loaded `Article` entity to the detail page, avoiding an extra network call when navigating from a list.

### Mock → Real Data Strategy

The project ships with `NewsMockDataSource` (returns hard-coded articles with realistic content). Switching to Firebase is a single line change in `injection_container.dart`:

```dart
// Change this:
sl.registerLazySingleton<NewsDataSource>(() => NewsMockDataSource());

// To this (after flutterfire configure):
sl.registerLazySingleton<NewsDataSource>(
  () => NewsFirestoreDataSource(FirebaseFirestore.instance),
);
```

The domain and presentation layers are completely unaffected by this swap.

---

## 3. UI / UX Decisions

- **Dark mode** supported out of the box via `ThemeMode.system`.
- **Breaking news PageView** at the top of the home feed, giving prominent placement to high-priority stories.
- **Category filter bar** with color-coded chips — each category has a distinct accent color for quick visual recognition.
- **Compact article cards** for the feed (thumbnail + headline + meta), **full cards** available for featured content.
- **Shimmer loading** skeletons instead of spinners for a more polished perceived-performance feel.
- **Swipe-to-delete** on the bookmarks list (Dismissible widget).
- **`CachedNetworkImage`** for all thumbnail loading, with placeholder and error fallback states.
- **Pull-to-refresh** on the home feed.

---

## 4. Firebase Integration Steps (to complete)

1. Create a Firebase project at console.firebase.google.com.
2. Enable **Firestore**, **Storage**, and optionally **Authentication**.
3. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
4. Run: `flutterfire configure` (generates `lib/firebase_options.dart`)
5. Uncomment the Firebase init block in `lib/main.dart`.
6. In `injection_container.dart`, swap `NewsMockDataSource` for `NewsFirestoreDataSource`.
7. Deploy Firestore rules: `firebase deploy --only firestore:rules`
8. Seed initial articles with the Firestore console or a seeding script.

---

## 5. What I Would Add With More Time

### Features
- **Firebase Authentication** — Google/Apple sign-in, syncing bookmarks across devices via Firestore sub-collection instead of SharedPreferences.
- **Infinite scroll / pagination** — Firestore `startAfterDocument` cursor-based pagination.
- **Push notifications** — Firebase Cloud Messaging for breaking news alerts.
- **Full-text search** — Replace the current prefix-match with Algolia or Typesense integration for proper full-text search.
- **Article read tracking** — Increment `views` counter via a Firebase Function to avoid client-side race conditions.

### Technical
- **CI/CD** — GitHub Actions pipeline: analyze → test → build → deploy to Firebase Hosting (for web) and App Distribution.
- **Unit tests** — Domain use-cases tested with `mocktail`; BLoC tested with `bloc_test`.
- **Widget tests** — Key screens tested with `flutter_test`.
- **Error monitoring** — Firebase Crashlytics integration.
- **Analytics** — Firebase Analytics events for article opens, category switches, search queries.

### Architecture Suggestions
- **Offline-first** — Cache Firestore results locally with `cloud_firestore`'s built-in offline persistence + a local SQLite layer for richer querying.
- **Feature flags** — Firebase Remote Config for gradual feature rollouts without app store updates.

---

## 6. Challenges & Decisions

| Challenge | Decision |
|---|---|
| No Figma access | Designed a clean, modern layout following Material Design 3 conventions with a clear hierarchy: breaking hero → category tabs → article list |
| Firestore full-text search limitation | Noted in code; recommended Algolia integration; current implementation does client-side filtering (sufficient for mock data) |
| Article detail page performance | Passed the `Article` entity via `go_router` `extra` to avoid a redundant Firestore read when navigating from a list |
| Bookmark persistence without auth | Used `shared_preferences` for local storage; documented how to migrate to Firestore once auth is added |
