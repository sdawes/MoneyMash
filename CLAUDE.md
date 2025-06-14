# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MoneyMash is an iOS SwiftUI application targeting iOS 18.5+ with Swift 5.0. The project uses a standard Xcode project structure with a single app target.

## Build Commands

- **Build the app**: `xcodebuild -project MoneyMash.xcodeproj -scheme MoneyMash -configuration Debug build`
- **Build for release**: `xcodebuild -project MoneyMash.xcodeproj -scheme MoneyMash -configuration Release build`
- **Run tests**: `xcodebuild -project MoneyMash.xcodeproj -scheme MoneyMash -destination 'platform=iOS Simulator,name=iPhone 15' test`
- **Clean build**: `xcodebuild -project MoneyMash.xcodeproj -scheme MoneyMash clean`

## Architecture

The app follows a standard SwiftUI app architecture:

- **MoneyMashApp.swift**: Main app entry point using the `@main` App protocol
- **ContentView.swift**: Root view of the application
- **Assets.xcassets/**: Contains app icons, accent colors, and other visual assets

The project uses:
- SwiftUI for the user interface framework
- Standard iOS app bundle identifier: `com.stevolution.MoneyMash`
- Development team ID: 5GD9WZ2Y4S
- SwiftUI previews are enabled for development

## Development Notes

- The project targets both iPhone and iPad (TARGETED_DEVICE_FAMILY = "1,2")
- SwiftUI previews are enabled in the build configuration
- Asset symbol extensions are automatically generated
- The app supports all standard iOS orientations for both iPhone and iPad