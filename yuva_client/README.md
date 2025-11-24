<div align="center">
  <img src="icons/Android/Icon-192.png" alt="Yuva Logo" width="120" height="120">
  <h1>Yuva - Home Cleaning Services Marketplace (Client App)</h1>
  
  <p>
    <a href="https://yuve-es.web.app" target="_blank">
      <img src="https://img.shields.io/badge/Demo-Live-brightgreen?style=for-the-badge&logo=firebase" alt="Live Demo">
    </a>
  </p>
</div>

A beautiful, modern Flutter mobile application that connects users with verified cleaning professionals, designed with a unique claymorphism aesthetic.

> **⚠️ Alpha Development Phase**: This application is currently in active development and is not yet publicly available on app stores (Google Play Store or Apple App Store). Stay tuned for our official launch!
>
> **🌐 Live Demo**: Experience the interface at [https://yuve-es.web.app](https://yuve-es.web.app)

## 📱 Overview

**Yuva** is a complete mobile platform for hiring home cleaning services. This is the **client-side application** for end users who want to hire cleaning professionals. A separate companion app exists for cleaning professionals to manage their services, bookings, and customer interactions.

The application implements a full multi-step booking flow, rating system, user profile management, and multi-language support. Currently uses dummy repositories with in-memory data, prepared for Firebase/REST backend integration in future phases.

### 🎭 Two-App Ecosystem

- **Yuva Client App** (this repository): For customers seeking cleaning services
- **Yuva Professional App** (separate repository): For cleaning professionals offering their services

## ✨ Implemented Features

### 🏗️ Clean Architecture

- **Layer Separation**: `/core`, `/design_system`, `/features`, and `/data`
- **State Management**: Riverpod for reactive state management
- **Repository Pattern**: Abstract interfaces to facilitate backend swapping
- **Dummy Implementations**: In-memory repositories with simulated delays for development

### 🌍 Internationalization (i18n)

- **Spanish (default language)** and **English** fully implemented
- Official Flutter system (`flutter_localizations` + `intl`)
- Over 330 localized text strings
- Language selector integrated in profile screen
- All enum labels use localization keys

### 🎨 Design System

Complete design system inspired by claymorphism with soft and friendly elements:

**Color Palette:**

- Primary: Soft Aqua/Teal (#7DCFCF)
- Accent: Warm Gold/Yellow (#FFD97D)
- Backgrounds: Soft warm gradients
- Full support for light and dark modes

**Typography:**

- Font: Nunito (via Google Fonts)
- Scalable styles: hero, title, subtitle, body, caption, label

**Reusable Components:**

- `YuvaButton` - Buttons with primary, secondary, ghost variants
- `YuvaCard` - Elevated cards with soft shadows
- `YuvaChip` - Chips for categories and filters
- `YuvaIconContainer` - Icon containers with "puffy" style
- `YuvaScaffold` - Custom scaffold with optional gradients

**Animations:**

- Custom page transitions
- Loading animations (loading dots)

### 📱 Main Screens

#### 1. **Splash Screen**

- Entry animation with fade and scale
- Warm gradient background
- Automatic navigation to onboarding or main screen

#### 2. **Onboarding** (3 slides)

- Slide 1: "Relax, your home stays brilliant"
- Slide 2: "Book in minutes"
- Slide 3: "Find trusted people for home cleaning"
- Page indicators and smooth transitions

#### 3. **Authentication** (Dummy)

- **Login**: Email and password
- **Sign Up**: Name, email, password
- "Continue as guest" option
- Dummy repository with preloaded users

#### 4. **Main Navigation** (Bottom Navigation Bar)

**Home:**

- Personalized user greeting
- Search bar
- Service category chips
- Featured cleaners list
- Quick access to booking flow

**Search:**

- Functional search bar
- Category filters
- Cleaner results

**My Bookings:**

- List of bookings with states: pending, in-progress, completed, cancelled
- Booking cards with detailed information
- Access to details of each booking
- Empty states when there are no bookings

**Profile:**

- User information with avatar
- Profile editing (name, email, phone)
- Language selector (ES/EN)
- Access to "My Reviews"
- Theme settings
- Logout button

#### 5. **Booking Flow** (6-Step Booking Process)

Complete guided process to create a booking:

1. **Service Type**: Selection of cleaning type
2. **Property Details**: Property type, size, bedrooms, bathrooms
3. **Frequency & Date**: Service frequency, date and time, estimated duration
4. **Address & Notes**: Complete address and additional notes
5. **Price Estimate**: Dynamic calculation based on selected parameters
6. **Summary**: Final confirmation before creating the booking

- Validation at each step
- Navigation with progress indicator
- Dynamic price calculation with `BookingPriceCalculator`
- Success screen after completing the booking

#### 6. **Booking Detail Screen**

- Complete booking information
- Current service status
- Date, duration, price details
- Option to rate completed service
- Cancellation of pending bookings

#### 7. **Rate Booking Screen**

- Star rating system (1-5)
- Optional comment field
- Rating validation
- Integration with ratings repository

#### 8. **My Reviews Screen**

- List of all user reviews
- Associated booking information
- Creation date of each review

### 📊 Data Models

**User** - Application user

- id, name, email, photoUrl, phone, createdAt

**Cleaner** - Cleaning professional

- id, name, photoUrl, rating, reviewCount, pricePerHour
- yearsExperience, specialties, bio, isVerified

**ServiceCategory** - Service category

- id, nameKey (localizable), iconName, color

**CleaningServiceType** - Cleaning service type

- id, titleKey, descriptionKey, iconName, baseRate

**BookingRequest** - Booking request

- id, userId, serviceTypeId
- propertyType, sizeCategory, bedrooms, bathrooms
- frequency, dateTime, durationHours
- addressSummary, notes, estimatedPrice
- status (pending, inProgress, completed, cancelled)
- hasRating

**Rating** - Service rating

- id, bookingId, userId, ratingValue (1-5)
- comment, createdAt

### 🧮 Services & Business Logic

**BookingPriceCalculator**

- Price calculation based on multiple factors
- Multipliers by property size (small, medium, large)
- Multipliers by frequency (once, weekly, biweekly, monthly)
- Use of service type base rate
- Rounding to 2 decimals for currency display

### 🗂️ Implemented Repositories

All repositories follow the abstraction pattern with interfaces and dummy implementations:

- **AuthRepository**: User authentication and session management
- **CleanerRepository**: Listing and search of cleaning professionals
- **CategoryRepository**: Available service categories
- **BookingRepository**: Complete CRUD of bookings and service types
- **RatingsRepository**: Rating and review system

## 🛠 Tech Stack

- **Flutter**: 3.38.1
- **Dart**: 3.10.0
- **Platforms**: Android, iOS, Linux, macOS, Windows, Web
- **State Management**: flutter_riverpod ^2.6.1
- **Fonts**: google_fonts ^6.2.1
- **Local Storage**: shared_preferences ^2.3.4
- **Utilities**: equatable ^2.0.7
- **Internationalization**: intl ^0.20.2

## 📁 Project Structure

```
lib/
├── core/
│   ├── providers.dart              # Global Riverpod providers
│   ├── settings_controller.dart    # Settings controller (language, theme)
│   └── l10n.dart                   # Localization exports
│
├── design_system/
│   ├── colors.dart                 # YuvaColors palette
│   ├── typography.dart             # YuvaTypography styles
│   ├── theme.dart                  # Light/dark themes
│   ├── animations/
│   │   ├── loading_animations.dart # Loading animations
│   │   └── page_transitions.dart   # Custom transitions
│   └── components/
│       ├── yuva_button.dart
│       ├── yuva_card.dart
│       ├── yuva_chip.dart
│       ├── yuva_icon_container.dart
│       └── yuva_scaffold.dart
│
├── data/
│   ├── models/                     # Domain models
│   │   ├── user.dart
│   │   ├── cleaner.dart
│   │   ├── service_category.dart
│   │   ├── cleaning_service_type.dart
│   │   ├── booking_request.dart
│   │   └── rating.dart
│   │
│   ├── repositories/               # Abstract interfaces
│   │   ├── auth_repository.dart
│   │   ├── cleaner_repository.dart
│   │   ├── category_repository.dart
│   │   ├── booking_repository.dart
│   │   └── ratings_repository.dart
│   │
│   ├── repositories_dummy/         # In-memory implementations
│   │   ├── dummy_auth_repository.dart
│   │   ├── dummy_cleaner_repository.dart
│   │   ├── dummy_category_repository.dart
│   │   ├── dummy_booking_repository.dart
│   │   └── dummy_ratings_repository.dart
│   │
│   └── services/
│       └── booking_price_calculator.dart
│
├── features/
│   ├── splash/
│   │   └── splash_screen.dart
│   │
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   │
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   │
│   ├── navigation/
│   │   └── main_navigation_screen.dart
│   │
│   ├── home/
│   │   └── home_screen.dart
│   │
│   ├── search/
│   │   └── search_screen.dart
│   │
│   ├── bookings/
│   │   ├── bookings_screen.dart
│   │   ├── booking_detail_screen.dart
│   │   ├── booking_success_screen.dart
│   │   ├── rate_booking_screen.dart
│   │   ├── booking_providers.dart
│   │   ├── booking_flow/
│   │   │   ├── booking_flow_screen.dart
│   │   │   └── booking_flow_state.dart
│   │   └── widgets/
│   │       └── booking_summary.dart
│   │
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   └── edit_profile_screen.dart
│   │
│   └── ratings/
│       ├── my_reviews_screen.dart
│       └── ratings_providers.dart
│
├── l10n/
│   ├── app_es.arb                  # Spanish translations (default)
│   └── app_en.arb                  # English translations
│
└── main.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.38.1 or higher
- Dart SDK 3.10.0 or higher
- Android Studio / Xcode for platform-specific development

### Installation

1. **Install dependencies**:

   ```powershell
   flutter pub get
   ```

2. **Generate localization files** (if needed):

   ```powershell
   flutter gen-l10n
   ```

3. **Run the application**:
   ```powershell
   flutter run
   ```

### Production Build

```powershell
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🎨 Design Philosophy

The Yuva app follows a **claymorphism** design approach:

- Soft rounded shapes with gentle shadows
- "Puffy" UI elements like cookies or clay
- Warm color palette (teal + gold)
- Friendly and accessible aesthetic
- Professional yet charming visual language

## 🔄 Features Roadmap

### 🚧 Current Status: Alpha Development

This application is in **alpha phase** and undergoing active development. Features are being tested and refined before public release.

### ✅ Implemented (Current Phase)

- ✅ Clean architecture with layer separation
- ✅ Complete design system with claymorphism
- ✅ Authentication system (dummy)
- ✅ Complete booking flow (6 steps)
- ✅ Booking management with multiple states
- ✅ Rating system
- ✅ Editable user profile
- ✅ Multi-language support (ES/EN)
- ✅ Cleaner search
- ✅ Dynamic price calculator
- ✅ Light and dark themes

### 🔜 Next Phases

**Phase 2: Backend Integration**

- Firebase Authentication
- Firestore database for persistent data
- Real-time synchronization
- Session and token management
- Image upload (avatars)

**Phase 3: Advanced Features**

- Integrated payment system (Stripe/PayPal)
- Chat/messaging between user and cleaner
- Push notifications
- Service history
- Favorites and saved cleaners
- Coupon/discount system
- Advanced search filters
- Geolocation and maps

**Phase 4: Optimization & Scalability**

- Unit and integration tests
- CI/CD pipeline
- Analytics and event tracking
- Performance optimization
- Robust error handling
- Logging and monitoring

**Phase 5: Public Release**

- Beta testing program
- App Store submission (iOS)
- Google Play Store submission (Android)
- Marketing and launch strategy
- User onboarding improvements
- Production monitoring and support

## 📝 Important Notes

- **Spanish is the default language** throughout the application
- All repositories are **abstracted** to facilitate backend swapping
- Navigation system supports **Android predictive back gestures**
- Icons from the `/icons` folder are properly integrated on both platforms
- The application is fully prepared for **light and dark themes**
- Enums use localization keys instead of hardcoded strings
- Price calculation is modular and can be easily replaced

## 🏛️ Architecture Decisions

1. **Repository Pattern**: Clean separation between data sources and UI
2. **State Management with Providers**: Riverpod for scalable state management
3. **Localization-First**: No hardcoded strings, all text is localized
4. **Component Library**: Reusable and consistent component system
5. **Future-Proof**: Ready for Firebase/HTTP integration without UI changes
6. **Enums with Localization Keys**: Maximum flexibility for translations
7. **Validation Layer**: Validations at each step of the booking flow
8. **Price Calculation Service**: Separated and testable business logic

## 🎯 Main Use Cases

1. **User searches for a cleaning service**

   - Home → Categories → Search → Select cleaner

2. **User creates a booking**

   - Home → "New Booking" → Booking Flow (6 steps) → Confirmation

3. **User manages their bookings**

   - My Bookings → View details → Cancel/Rate

4. **User rates a completed service**

   - My Bookings → Completed booking → Rate → Submit review

5. **User edits their profile**

   - Profile → Edit Profile → Update data → Save

6. **User changes language**
   - Profile → Language → Select ES/EN

## 🤝 Contributing

To contribute to the project:

1. Fork the repository
2. Create a branch for your feature (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is private and confidential.

## ℹ️ Additional Information

- **App Type**: Client-side application (customer/user facing)
- **Development Status**: Alpha (not publicly available)
- **Target Platforms**: iOS and Android
- **Companion App**: A separate professional app exists for service providers
- **Availability**: Not yet released on Google Play Store or Apple App Store

---

**Built with ❤️ using Flutter 3.38.1**
