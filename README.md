# YUVA - Flutter Multi-App Project

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Authentication-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-Portfolio-green?style=for-the-badge)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-jozzer182-181717?style=for-the-badge&logo=github)](https://github.com/jozzer182)

> **Note**: This is a portfolio/demonstration project showcasing Flutter development skills with Firebase integration and multi-app architecture.

## 📱 Project Overview

YUVA is a Flutter-based project consisting of two complementary applications:

<table>
<tr>
<td align="center" width="50%">
<img src="yuva_client/icons/iOS/Icon-1024.png" width="120" alt="YUVA Client Icon"/><br/>
<b>YUVA Client</b><br/>
<em>Client-facing application</em>
</td>
<td align="center" width="50%">
<img src="yuva_worker/icons/iOS/Icon-1024.png" width="120" alt="YUVA Worker Icon"/><br/>
<b>YUVA Worker</b><br/>
<em>Service provider application</em>
</td>
</tr>
</table>

Both applications share a common architecture and are built with modern Flutter best practices, featuring Firebase Authentication with advanced security features.

## ✨ Key Features

### Authentication & Security

- ✅ Firebase Authentication integration
- ✅ Email/Password authentication
- ✅ Google Sign-In (OAuth 2.0)
- ✅ Multi-Factor Authentication (MFA)
- ✅ Email verification
- ✅ Secure session management

### Architecture

- Clean Architecture principles
- Feature-based folder structure
- Shared design system
- Responsive UI/UX
- Multi-platform support (Android, iOS, Web, Windows, macOS, Linux)

## 🏗️ Project Structure

```
yuva/
├── yuva_client/          # Client application
│   ├── lib/
│   │   ├── core/         # Core utilities and services
│   │   ├── data/         # Data layer (repositories, models)
│   │   ├── design_system/# Shared UI components
│   │   ├── features/     # Feature modules
│   │   └── l10n/         # Internationalization
│   └── ...
│
├── yuva_worker/          # Worker application
│   ├── lib/
│   │   ├── core/
│   │   ├── data/
│   │   ├── design_system/
│   │   ├── features/
│   │   └── l10n/
│   └── ...
│
└── docs/                 # Technical documentation
    ├── auth-checklist-flutter.md
    ├── firebase-auth-architecture-flutter.md
    ├── google-signin-setup.md
    └── mfa-implementation-summary.md
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase CLI
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/jozzer182/yuva.git
   cd yuva
   ```

2. **Install dependencies for both apps**

   ```bash
   # Client app
   cd yuva_client
   flutter pub get

   # Worker app
   cd ../yuva_worker
   flutter pub get
   ```

3. **Configure Firebase** (Required for authentication)

   ⚠️ **Important**: Firebase configuration files are not included in this repository for security reasons.

   You need to:

   - Create your own Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google Sign-In)
   - Download your own `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Run `flutterfire configure` to generate `firebase_options.dart`

   See [Firebase Setup Guide](docs/google-signin-setup.md) for detailed instructions.

4. **Run the applications**

   ```bash
   # Client app
   cd yuva_client
   flutter run

   # Worker app
   cd yuva_worker
   flutter run
   ```

## 🔐 Security Notes

This repository follows security best practices:

- ❌ No API keys or secrets in version control
- ❌ No Firebase configuration files committed
- ✅ All sensitive files listed in `.gitignore`
- ✅ Each developer must configure their own Firebase project

**Files you need to create locally** (not in repo):

- `firebase_options.dart` (both apps)
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)
- `firebase.json` (project root)

## 📚 Documentation

Detailed documentation is available in the `/docs` folder:

- [Firebase Authentication Architecture](docs/firebase-auth-architecture-flutter.md)
- [Google Sign-In Setup](docs/google-signin-setup.md)
- [MFA Implementation](docs/mfa-implementation-summary.md)
- [Authentication Checklist](docs/auth-checklist-flutter.md)

## 🛠️ Technologies Used

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Material Design](https://img.shields.io/badge/Material%20Design%203-757575?style=flat-square&logo=material-design&logoColor=white)

- **Framework**: Flutter & Dart
- **Authentication**: Firebase Authentication
- **State Management**: Provider / Riverpod
- **Backend Services**: Firebase
- **Architecture**: Clean Architecture
- **Design**: Material Design 3
- **Internationalization**: ARB files (English & Spanish)

## 📱 Supported Platforms

<p align="center">
<img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android"/>
<img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS"/>
<img src="https://img.shields.io/badge/Web-4285F4?style=for-the-badge&logo=google-chrome&logoColor=white" alt="Web"/>
<img src="https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Windows"/>
<img src="https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white" alt="macOS"/>
<img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux"/>
</p>

## 🤝 Contributing

This is a portfolio project, but suggestions and feedback are welcome!

## 📄 License

This project is for educational and portfolio purposes.

## 👨‍💻 Author

Jose Zarabanda

- GitHub: [@jozzer182](https://github.com/jozzer182)
- Email: jlzarabandad@gmail.com

---

**Note for Recruiters**: This project demonstrates:

- Modern Flutter development practices
- Firebase integration and security
- Multi-app architecture
- Clean code principles
- Documentation skills
- Security awareness (proper handling of secrets and API keys)
