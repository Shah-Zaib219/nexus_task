# 🛒 Nexus Commerce

Nexus Commerce is a modern, feature-rich mini e-commerce mobile application built with **Flutter**, developed as part of the *Brief Flutter Development Assignment*.
The application follows clean architecture principles, implements scalable state management, and integrates with RESTful APIs to provide a smooth and responsive shopping experience.

---

## 🔑 Demo Login Credentials

Use the following credentials to log in:

```
Username: mor_2314
Password: 83r5^_
```

> ⚠️ For evaluation and testing purposes only.

---

## 📱 Platforms Supported

* Android
* iOS
* Web (limited support)

---

## 🚀 Tech Stack

* Flutter (Dart)
* Bloc / Cubit (State Management)
* MVVM Architecture
* Dio (HTTP Networking)
* Flutter Secure Storage (Secure Token Storage)

---

## 🎯 Key Features

### 🔐 Authentication

* Login using `/auth/login`
* User registration via `/users`
* Secure token storage
* Auto-login if token exists

### 🛍 Product Browsing

* Fetch products from `/products`
* Product details page
* Category filtering
* Pull-to-refresh

### 🛒 Cart Management

* Add/remove products
* Quantity control
* Persistent cart state
* Total price calculation

### 👤 User Profile

* Display user data
* Fetch from `/users/:id`

### 🎨 UI / UX

* Light & Dark themes
* Responsive layouts
* Smooth animations
* Loading & error states

---

## 🏗 Architecture Overview

The app uses **MVVM with Bloc/Cubit**:

```
View (UI)
   ↓
Cubit / Bloc (State)
   ↓
Repository
   ↓
Remote Data Source (API)
```

Benefits:

* Separation of concerns
* Testable logic
* Scalable codebase

---

## 📂 Project Structure

```
lib/
 ├── core/           # Constants, themes, helpers
 ├── data/           # Models, repositories, services
 ├── logic/          # Cubits & states
 ├── presentation/  # Screens & widgets
 └── main.dart
```

---

## 📦 Assets

Ensure these files exist:

```
assets/images/logo.png
assets/images/logo1.png
```

---

## ▶️ Getting Started

### Prerequisites

* Flutter SDK installed
* Android Studio / VS Code
* Emulator or physical device

### Installation

```bash
git clone https://github.com/Shah-Zaib219/nexus_commerce.git
cd nexus_commerce
flutter pub get
flutter run
```

---

## 🏗 Build Release APK

```bash
flutter build apk --release
```

Output:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧪 Testing

Run unit tests:

```bash
flutter test
```

---

## 🔌 API Endpoints Used

* `/auth/login`
* `/users`
* `/users/:id`
* `/products`
* `/products/:id`

---

## 🧠 State Management

Each feature has its own Cubit:

* AuthCubit
* ProductCubit
* CartCubit
* ProfileCubit

This keeps logic modular and easy to maintain.

---

## 🔒 Security

* Tokens stored using FlutterSecureStorage
* No credentials hard-coded in source

---

## 🚧 Future Improvements

* Wishlist feature
* Order history
* Checkout & payment gateway
* Offline caching
* Push notifications

---

## 👨‍💻 Author

**Shah Zaib**
Flutter Developer

GitHub: [https://github.com/Shah-Zaib219](https://github.com/Shah-Zaib219)

---
