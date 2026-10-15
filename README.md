# Expense Tracker

A Flutter application for recording income and expenses, reviewing transactions, and managing budget preferences. The app includes local sign-up and login screens and saves its data on the device.

## Features

- Record salary and other income, and add expenses with a category and date.
- Review and delete transactions from the dashboard or transaction list.
- Search transactions and view category breakdowns.
- Set a monthly budget and track spending against it.
- Select a currency symbol and manage categories.
- View profile and app settings, including notification and theme controls.
- Navigate to additional pages for bills, subscriptions, notes, and loans.
- Sign up and log in using locally stored account information.

Newly registered accounts start with an empty transaction list, so income and expenses can be entered manually.

## Project Structure

```text
.
├── analysis_options.yaml
├── pubspec.yaml                 # Package metadata, dependencies, assets, and fonts
├── pubspec.lock                 # Resolved dependency versions
├── README.md
├── lib/
│   ├── main.dart                # App startup, authentication gate, and page navigation
│   ├── models/
│   │   └── expense.dart         # TransactionItem model and JSON conversion
│   ├── screens/
│   │   ├── about_page.dart
│   │   ├── add_expense_page.dart
│   │   ├── add_salary_page.dart
│   │   ├── analytics_page.dart
│   │   ├── bills_page.dart
│   │   ├── budget_page.dart
│   │   ├── categories_page.dart
│   │   ├── currency_settings_page.dart
│   │   ├── dashboard_page.dart
│   │   ├── export_page.dart
│   │   ├── goals_page.dart
│   │   ├── loans_page.dart
│   │   ├── login_page.dart
│   │   ├── net_worth_page.dart
│   │   ├── notes_page.dart
│   │   ├── profile_settings_page.dart
│   │   ├── reports_page.dart
│   │   ├── search_page.dart
│   │   ├── signup_page.dart
│   │   ├── subscriptions_page.dart
│   │   ├── tax_page.dart
│   │   └── transaction_list_page.dart
│   ├── services/
│   │   └── storage_service.dart  # SharedPreferences persistence and local auth
│   ├── theme/
│   │   └── liquid_glass_theme.dart
│   ├── widgets/
│   │   ├── expense_tile.dart
│   │   ├── glass_bottom_nav.dart
│   │   ├── glass_container.dart
│   │   └── resourse/             # Legacy resource helpers (spelling retained in code)
│   └── resource/
│       ├── animations/           # Animation assets and helpers
│       ├── colors/               # App color definitions
│       ├── data/                 # JSON and Dart app data
│       ├── fonts/                # Bundled Poppins font files and definitions
│       ├── icons/                # App icon assets and definitions
│       ├── images/               # Logos, illustrations, and other images
│       └── placeholders/         # Empty-state and placeholder images
├── test/
│   └── widget_test.dart
├── scratch/                      # Development scripts for assets and HTML output
├── android/                      # Android project
├── ios/                          # iOS project
├── macos/                        # macOS project
├── web/                          # Web project
└── windows/                      # Windows project
```

The `analytics_page.dart`, `export_page.dart`, `goals_page.dart`, `net_worth_page.dart`, `reports_page.dart`, and `tax_page.dart` files exist in the source tree but are not currently wired into the main navigation in `main.dart`.

## Storage and Authentication

- Transactions, budget, currency, categories, profile, and preferences are persisted with `shared_preferences` on the current device.
- Sign-up initializes the transaction list as empty. Other locally saved preferences are not stored in a cloud account.
- Login is a local prototype flow, not server-backed authentication. It does not provide account sync or production-grade credential security; do not use a sensitive password for this app.
- Before an account is registered, the login flow has a built-in demo fallback: `alex.morgan@example.com` with password `123456`.
- There is no backend or cloud backup. Clearing app storage or uninstalling the app can remove saved data.

## Requirements

- Flutter SDK with Dart SDK `^3.12.2` support, as declared in `pubspec.yaml`.
- Android Studio and an Android SDK for Android builds, Xcode for iOS/macOS builds, or the relevant toolchain for web and Windows.

Platform project directories are included for Android, iOS, macOS, web, and Windows. Availability of a platform directory does not guarantee that its build has been tested on your machine.

## Run the App

From the repository root:

```bash
flutter pub get
flutter run
```

To choose a connected device or emulator, list available targets with `flutter devices`, then run `flutter run -d <device-id>`.

## Test and Analyze

```bash
flutter test
flutter analyze
```

## Dependencies

- `shared_preferences` for local persistence.
- `google_fonts` and `flutter_animate` for typography and animation support.
- `cupertino_icons` for Cupertino-style icons.
- Poppins font files are bundled under `lib/resource/fonts/`.
