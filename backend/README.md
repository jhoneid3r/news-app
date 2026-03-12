# Backend — Firebase

## Prerequisites

- Firebase CLI: `npm install -g firebase-tools`
- Login: `firebase login`
- Select project: `firebase use <your-project-id>`

## Firestore Rules

Rules are defined in `firestore.rules`. Deploy with:

```bash
firebase deploy --only firestore:rules
```

## Firestore Indexes

Indexes are defined in `firestore.indexes.json`. Deploy with:

```bash
firebase deploy --only firestore:indexes
```

## Storage Rules

Storage rules are defined in `storage.rules`. Deploy with:

```bash
firebase deploy --only storage
```

## Full Deploy

```bash
firebase deploy
```

## Schema

See `docs/DB_SCHEMA.md` for the full database schema documentation.
