# Somnio's Flutter Boilerplate

This project was developed by Somnio Software as an app to be used as a boilerplate, making easy to start developing new apps or projects and as a repository to reuse generic widgets, services, models, etc. previously implemented on a working project.


### Supported sign-in methods

- [x] Anonymous
- [x] Email & Password
- [ ] Email link (passwordless)
- [x] Facebook
- [ ] GitHub
- [x] Google
- [x] Apple
- [ ] Phone
- [ ] Twitter

### Other authentication features

- [x] Email verification (for email & password sign-in)
- [x] Password reset
- [ ] Sign-in with custom token

## Application features

### Sign-in Page

- [x] Email and password sign-in
- [x] Apple sign-in
- [x] Google sign-in
- [x] Facebook sign-in

- [x] Custom submit button with loading state
- [x] Disable all input widgets while authentication is in progress
- [x] Email regex validation
- [x] Error hints
- [ ] Focus order (email -> password -> submit by pressing "next" on keyboard)
- [x] Password of at least 6 characters, with at least 1 number, 1 capital letter and 1 lowercase letter
- [x] Show/hide password
- [x] Password reset flow

### Email link page

- [ ] Email input field, backed by secure storage
### Architecture

- [x] Logic inside models for better separation of concerns (using [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html))
- [x] Use [Provider package](https://pub.dev/packages/provider) for dependency injection
### User models

-[x] Admin with different capabilities from user
-[x]
### Other

- [x] Use [`Shared Preferences](https://pub.dev/packages/shared_preferences), a providing persistent storage for simple data
- [x] Use [`Image Picker`](https://pub.dev/packages/image_picker) for picking images from the library and taking photos
- [x] Custom App light and dark theme
- [x] 

## Services

### Authentication

- [x] Abstract `AuthService` class, modeled after the `firebase_auth` API
- [x] `FirebaseAuthService` implementation
- [ ] `MockAuthService` for testing
- [x] Firebase project configuration for iOS & Android
- [ ] Toggle `FirebaseAuthService` and `MockAuthService` at runtime via developer menu
### Storage 

-[x] Abstract `StorageService` class, modeled after `firebase_storage` API
-[x] `FirebaseStorageService` implementation
### Persistence s

-[x] Abstract `PersistenceService` class, modeled after `cloud_firestore` API
-[x] `FirebasePersistenceService` implementation