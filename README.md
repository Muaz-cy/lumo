# Lumo — Your home, back home.

> A premium real-estate platform built for the Ethiopian diaspora — browse, compare, and inquire on properties back home, from anywhere in the world.

---

## 📽️ Demo Video

[![Watch the demo](https://img.shields.io/badge/Watch%20Demo-Click%20Here-red?style=for-the-badge&logo=youtube)](YOUR_VIDEO_LINK_HERE)

---

## What is Lumo?

Lumo bridges the gap between Ethiopians living abroad and the real-estate market back home. Whether you're looking to buy, rent, or invest, Lumo gives you a trusted, beautifully designed platform to explore properties in Addis Ababa and beyond — in your language, your currency.

---

## Key Features

- **Property Discovery** — Browse featured listings, filter by type (buy/rent), neighborhood, price range, and bedrooms
- **Interactive Map** — Explore properties on a live map with neighborhood overlays
- **Property Comparison** — Side-by-side comparison of up to 3 properties
- **Broker Portal** — Dedicated dashboard for brokers to submit and manage listings
- **Consultation Booking** — Schedule a call with a broker directly from the app
- **ETB / USD Toggle** — Live exchange rate with automatic currency conversion
- **Amharic / English** — Full localization in both languages
- **Dark & Light Mode** — System-aware theming with a warm Ethiopian design palette
- **Authentication** — Email/password and anonymous browsing via Supabase Auth

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3 |
| State Management | Riverpod (riverpod_generator) |
| Navigation | GoRouter |
| Backend & Auth | Supabase |
| Maps | flutter_map + OpenStreetMap |
| Animations | flutter_animate |
| Local Storage | SharedPreferences, Hive |
| Architecture | Feature-first Clean Architecture |

---

## Project Structure

```
lib/
├── core/           # Router, config, theme
├── features/       # home, search, property, broker, auth, consultation, ...
├── shared/         # Design system, providers, widgets
└── l10n/           # English & Amharic translations
```

---

## Running Locally

```bash
# 1. Install dependencies
flutter pub get

# 2. Run code generation
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

> Requires Flutter SDK ≥ 3.12.2 and a configured Supabase project.

---

## Design System

Lumo uses a custom design system (`lib/shared/design_system/`) built around a warm Ethiopian color palette, the Geist typeface, and a consistent spacing/motion system — ensuring every screen feels intentional and premium.

---

## Team

**Solo Project**

| Name | ID |
|---|---|
| Muaz Khalid | CTC-1913 |
