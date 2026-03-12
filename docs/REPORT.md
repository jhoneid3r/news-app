# NewsFlow — Project Report

## 1. Introduction

Coming into this project, I have around 5 years of programming experience, mostly working with cross-platform mobile development using React Native. I had briefly explored Flutter before, but never built anything substantial with it — this project was my first real deep dive into the framework.

On the backend side, I was not starting from zero with Firebase. I had previously worked with Firebase Cloud Messaging for push notifications, so I was comfortable with the Firebase ecosystem in general. However, Firestore and Firebase Cloud Storage were services I had never used before, so this project pushed me into new territory on both the frontend and backend sides.

---

## 2. Learning Journey

Since Flutter was new to me at this depth, I had to learn a lot in a short time. My main resources were:

- **YouTube courses** — short, focused tutorials to get up to speed quickly on Flutter widgets, navigation, and state management.
- **Flutter official documentation** — the Flutter docs are excellent and I referenced them constantly throughout development.
- **AI assistance** — used to understand concepts faster, clarify doubts, and work through architectural decisions. More on this in the next section.

Coming from React Native, the mental model shift to Flutter was smoother than expected. Flutter's widget tree felt more structured and predictable than JSX components. The fact that everything is a widget — padding, styling, layout — made the UI code more consistent and easier to reason about.

For Firebase specifically, I had to learn Firestore's document/collection model, security rules syntax, and the Cloud Storage API. The FlutterFire CLI made the initial Firebase-Flutter connection surprisingly straightforward.

---

## 3. AI-Driven Development

This entire application was built from scratch using AI — specifically **Claude Code** by Anthropic.

This was a deliberate choice, and one I believe reflects where software development is heading. My view is that **today it is no longer strictly necessary to learn every new technology from scratch before using it productively**. What matters more is knowing how to work with AI effectively so it can do the heavy lifting while you stay in control of the direction and quality of the output.

That said, working with AI is not just typing prompts and accepting whatever comes back. During this project I applied the following practices:

- **Review everything the AI produces.** I read every file, every function, every change before accepting it. AI can generate plausible-looking code that has subtle bugs or architectural mismatches with the rest of the project.
- **Give precise, contextual instructions.** Vague prompts produce vague results. The more specific the instruction — including constraints, existing patterns, and expected behavior — the better the output.
- **Catch and correct mistakes.** There were serialization bugs, missing imports, firestore rule misconfigurations, and more. Identifying these required understanding the codebase well enough to spot when something was wrong, even if AI wrote it.
- **Own the architecture.** The high-level decisions — Clean Architecture, BLoC, the Firestore schema design, the Storage folder structure — were guided and validated by me. AI executes; the developer directs.
- **Iterate, don't just accept.** When a generated solution did not fit, I pushed back with specific feedback rather than working around bad output.

The result is a fully functional, production-quality Flutter application connected to a real Firebase backend — built in a fraction of the time it would have taken learning Flutter and Firestore from zero in the traditional way.

This is not about replacing developer knowledge. It is about **leveraging AI as a force multiplier** — and knowing how to use that multiplier responsibly is itself a skill worth developing.

---

## 4. Challenges Faced

Honestly, the hardest part of the entire project was the **initial setup and environment configuration**. This is something every developer knows but nobody talks about enough — getting all the tools, SDKs, CLI versions, and dependencies aligned and working together took significant time. There were always small issues: outdated packages, SDK version conflicts, environment variables not set correctly, Firebase CLI not detecting the project directory. Every time one thing was fixed, another would surface.

Once the environment was stable, development itself was much smoother. But that initial phase of fighting the toolchain was genuinely the most frustrating part of the experience.

---

## 5. Reflection and Future Directions

### What I Enjoyed

The most interesting part of the project was **connecting the Flutter frontend to Firebase**. There is something satisfying about seeing data you seeded in a Node.js script appear live in a mobile app — with images uploaded to Firebase Storage, URLs stored in Firestore, and the app rendering everything correctly. The full-stack loop from backend script to mobile UI felt complete.

I also genuinely enjoyed Flutter more than I expected. Having used React Native before, I went in thinking the experience would be similar, but Flutter felt more intuitive and comfortable to work with. The widget system is consistent, the hot reload is fast, and the overall developer experience is polished.

### What I Would Do Differently

If I started this project from scratch, I would **connect Firebase from day one** instead of building with mock data first. While the mock-first approach is architecturally clean and the datasource swap is easy, I spent extra time debugging integration issues that would have surfaced earlier if Firebase had been connected from the start. Starting with real data earlier would have caught schema mismatches and serialization bugs sooner.

### Future Improvements

- **Firebase Authentication** — Google/Apple sign-in, and syncing bookmarks across devices via Firestore instead of SharedPreferences.
- **Pagination** — Firestore cursor-based pagination (`startAfterDocument`) for large article feeds.
- **Push notifications** — Firebase Cloud Messaging for breaking news alerts.
- **Full-text search** — Algolia or Typesense integration to replace the current client-side filtering.
- **CI/CD pipeline** — GitHub Actions: analyze → test → build → Firebase App Distribution.
- **Unit and widget tests** — Domain use-cases tested with `mocktail`, BLoC with `bloc_test`.

---

## 6. Project Demo

### Screenshots & Video Demo

> 📁 [View screenshots and full demo video on Google Drive](https://drive.google.com/drive/folders/1fOYS0WQBOypDe93tqgT2f5euSjuVYi91?usp=drive_link)

---

## 7. Overdelivery

Beyond the core requirements, several additional features were implemented:

### Image Upload When Creating an Article

The Create Article screen allows users to attach an image from their device gallery. When published:

1. The image is uploaded to Firebase Cloud Storage at `media/articles/user_{timestamp}.jpg`.
2. The public download URL is saved to the article's `thumbnailURL` field in Firestore.
3. The article appears immediately in the feed with the uploaded image.

This demonstrates the full write path: device gallery → Storage → Firestore → live in the feed.

### Theme Toggle (Light / Dark / System)

A `ThemeCubit` was implemented that cycles through light → dark → system theme modes. The selected mode is persisted across app sessions using `SharedPreferences`, so the user's preference is remembered after closing the app.

### Shimmer Loading Skeletons

Instead of a plain spinner, the app shows animated shimmer placeholders while articles are loading — including when switching categories, where a shimmer replaces the list until the new data arrives. This improves perceived performance and gives the app a more polished feel.

### Swipe-to-Delete on Bookmarks

The bookmarks list supports swipe-to-delete using Flutter's `Dismissible` widget, with a red background and delete icon revealed on swipe — a native-feeling interaction.

### Firebase Storage Seed Script

The backend seed script (`backend/scripts/seed.js`) goes beyond inserting text data. It:

1. Downloads images from Unsplash for each article.
2. Uploads them to Firebase Cloud Storage under `media/articles/`.
3. Saves the Storage public URL to Firestore's `thumbnailURL` field.

This means the app has zero dependency on Unsplash or any third-party image CDN at runtime — all images are served from Firebase Storage.

### Architecture Prototype — Clean Architecture Diagram

The project follows Clean Architecture with three layers per feature:

```
┌─────────────────────────────────────────────┐
│              Presentation Layer              │
│         BLoC / Cubit · Pages · Widgets       │
└────────────────────┬────────────────────────┘
                     │ calls use cases
┌────────────────────▼────────────────────────┐
│               Domain Layer                   │
│    Entities · Use Cases · Repository Interface│
│         (zero Flutter/Firebase imports)       │
└────────────────────┬────────────────────────┘
                     │ implemented by
┌────────────────────▼────────────────────────┐
│                Data Layer                    │
│   Models · Firestore DataSource · Repo Impl  │
│         Mock DataSource (for testing)         │
└─────────────────────────────────────────────┘
```

The key benefit: swapping Firebase for any other backend only requires changing the datasource registration in `injection_container.dart` — the domain and presentation layers are completely unaffected.

### How to Improve Further

- **Offline-first** — Firestore's built-in offline persistence already caches reads. Adding a local SQLite layer would allow richer offline querying and a fully functional offline mode.
- **Firebase Remote Config** — Feature flags for gradual rollouts without requiring app store updates.
- **Article analytics** — Firebase Analytics events for article opens, category switches, and search queries to understand user behavior.
- **Distributed view counters** — Replace the current `views` field increment with a Firebase Cloud Function to avoid race conditions at scale.

---

## 8. Additional Notes

### Tech Stack Summary

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| State Management | BLoC / Cubit |
| Navigation | go_router |
| Dependency Injection | GetIt |
| Database | Firebase Firestore |
| File Storage | Firebase Cloud Storage |
| Local Persistence | SharedPreferences |
| Image Loading | CachedNetworkImage |
| Architecture | Clean Architecture |
| AI Tool | Claude Code (Anthropic) |

### Repository

Both branches are available on GitHub:
- `master` — implements the design requested in the project brief, with full Firebase integration
- `custom-design` — implements my own custom design, built to my personal taste with additional UI polish, animations, and extra features beyond the requirements
