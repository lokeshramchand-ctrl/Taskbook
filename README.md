# Taskbook

A tiny, mobile-first Flutter app for writing Todo items that become GitHub
Issues. There is no login, no accounts, and no database — GitHub Issues in
one fixed repository are the only source of truth.

The app is permanently wired to:

```
https://github.com/lokeshramchand-ctrl/Docs/issues
```

## What it does

- **My Taskbook** (home): two buttons, nothing else.
- **Create New Issue**: a title field and a Markdown editor. Enter is always
  a newline; the `Create Issue` button (or Cmd/Ctrl+Enter on desktop) submits.
  Write GitHub task lists directly, e.g. `- [ ] Call the bank`.
- **View All Issues**: every issue in the repo as a simple list — open
  issues are active tasks, closed issues show as completed.
- **Issue detail**: renders `- [ ]` / `- [x]` lines as real checkboxes.
  Tapping one updates the issue body on GitHub directly. An "Open on GitHub"
  button hands off to the browser or the GitHub app for anything else.

## Architecture

There is no backend server. The app talks to the GitHub REST API directly:

```
Phone
  -> Taskbook (Flutter)
  -> GitHub REST API
  -> lokeshramchand-ctrl/Docs Issues
```

The GitHub personal access token never lives in source code. It's entered
once, on first launch, and stored in OS-level secure storage (iOS Keychain /
Android Keystore-backed EncryptedSharedPreferences) via
`flutter_secure_storage`. You can replace it later from the key icon on the
home screen.

Because this build has no server sitting between the device and GitHub, the
token lives in secure storage on that one device rather than an environment
variable — there's nothing to keep server-side. Keep this app private to
your own device(s); anyone with the compiled app and the token could write
issues to the repo.

## Setup

1. Create a fine-grained GitHub personal access token scoped to just the
   `Docs` repository, with **Issues: Read and write** permission (and
   nothing else).
2. Run the app (`flutter run`) and paste that token into the one-time setup
   screen. Done — no further configuration.

## Getting Started (Flutter)

```
flutter pub get
flutter run
```

- [Flutter docs](https://docs.flutter.dev/)
