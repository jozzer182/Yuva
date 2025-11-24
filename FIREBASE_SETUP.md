# Firebase Configuration Template

# ⚠️ IMPORTANT: DO NOT COMMIT REAL FIREBASE CONFIGURATION FILES TO GIT!

## Required Files (Not in Repository)

You need to create these files locally after setting up your own Firebase project:

### 1. firebase_options.dart
Location: 
- `yuva_client/lib/firebase_options.dart`
- `yuva_worker/lib/firebase_options.dart`

Generate with:
```bash
flutterfire configure
```

### 2. google-services.json (Android)
Location:
- `yuva_client/android/app/google-services.json`
- `yuva_worker/android/app/google-services.json`

Download from Firebase Console → Project Settings → Your Android Apps

### 3. GoogleService-Info.plist (iOS)
Location:
- `yuva_client/ios/Runner/GoogleService-Info.plist`
- `yuva_worker/ios/Runner/GoogleService-Info.plist`

Download from Firebase Console → Project Settings → Your iOS Apps

### 4. firebase.json (Project Root)
Location: `yuva/firebase.json`

Can be generated with:
```bash
firebase init
```

## Setup Instructions

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing
3. Add Android/iOS apps with appropriate package names:
   - Client: `com.example.yuva` (or your package name)
   - Worker: `com.example.yuva_worker` (or your package name)
4. Enable Authentication methods:
   - Email/Password
   - Google Sign-In
5. Download configuration files as listed above
6. Run `flutterfire configure` in each app directory
7. Test the setup by running the apps

## Security Reminder

These files contain:
- API Keys
- OAuth Client IDs
- Project IDs
- App IDs

**NEVER commit them to version control!**

They are already listed in `.gitignore` for your protection.
