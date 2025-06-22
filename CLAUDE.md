# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application called "goosWidget" - a widget app for memos and D-Day counters. The project is currently in initial development stage with the default Flutter counter app template.

## Development Commands

### Essential Commands
```bash
flutter pub get              # Install dependencies
flutter run                  # Run app in development mode
flutter clean               # Clean build files when needed
flutter analyze             # Run static analysis
flutter test                # Run tests
```

### Building
```bash
flutter build apk          # Build Android APK
flutter build appbundle    # Build Android App Bundle
flutter build ios          # Build iOS (macOS only)
```

## Architecture

### Current State
- Single `lib/main.dart` file with default counter app
- Minimal dependencies (only cupertino_icons)
- Standard Flutter project structure

### Planned Architecture (from docs/PRD.md)
The app will implement:
- **Memo Widgets**: Customizable text display widgets
- **D-Day Widgets**: Date countdown/countup functionality  
- **Widget Management**: CRUD operations for user widgets
- **Local Storage**: SharedPreferences for data persistence
- **Home Screen Integration**: Native platform widgets via home_widget package

### Required Dependencies (not yet added)
- `shared_preferences` - Local data storage
- `home_widget` - Native platform widget integration
- Additional UI packages for color/date selection

## Key Files

- `docs/PRD.md` - Comprehensive product requirements (Korean)
- `lib/main.dart` - Main application entry point
- `pubspec.yaml` - Project configuration and dependencies
- `analysis_options.yaml` - Code analysis configuration

## Development Notes

- Project uses Korean language for documentation and will target Korean users
- Code quality enforced via `flutter_lints: ^5.0.0`
- Currently needs proper folder structure implementation (`widgets/`, `screens/`, `models/`, `services/`)
- State management solution needed for widget data persistence