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

MoneyMash follows iOS/SwiftUI best practices with a well-organized folder structure:

```
MoneyMash/
├── App/                        # App entry point and root views
│   ├── MoneyMashApp.swift     # Main app entry point using @main App protocol
│   └── ContentView.swift      # Root view of the application
├── Models/                     # Data models and sample data
│   ├── FinancialAccount.swift # Core account model with SwiftData
│   ├── BalanceUpdate.swift    # Balance history entries
│   ├── SampleData.swift       # Debug sample data population
│   └── Theme.swift            # App theming and styling constants
├── Views/                      # Main application screens
│   ├── Account/               # Account-related views
│   │   ├── AccountListView.swift    # Main screen with summary and account cards
│   │   ├── AccountDetailView.swift  # Individual account details
│   │   └── AddAccountView.swift     # New account creation form
│   └── Summary/               # Summary-related views
│       └── SummaryView.swift  # Net worth summary with controls
├── Components/                 # Reusable UI components
│   ├── Cards/                 # Card-based UI components
│   │   ├── AccountCardView.swift      # Account display card
│   │   ├── AccountHeaderCard.swift    # Account header with balance
│   │   ├── BalanceHistoryCard.swift   # Balance history display
│   │   └── BalanceUpdateForm.swift    # Balance update form
│   └── Charts/                # Chart components
│       └── AccountChartView.swift     # Swift Charts integration
└── Resources/                  # Assets and resources
    └── Assets.xcassets/       # App icons, colors, and visual assets
```

### **Data Models (SwiftData)**
- **FinancialAccount**: Core account model with balance tracking and performance metrics
- **BalanceUpdate**: Individual balance entries with timestamps
- **AccountType**: Enum covering all financial account types (savings, investments, debt, etc.)
- **SampleData**: Provides realistic sample data for development and testing

### **Key Features**
- Unified scrolling design throughout the app
- Card-based UI with gray cards on white background
- Smart debt vs asset account handling with contextual trend indicators
- Monthly performance calculations with percentage changes
- Interactive charts showing balance history over time
- Net worth calculation with configurable pension/mortgage inclusion

### **Technical Stack**
- SwiftUI for user interface framework
- SwiftData for data persistence and relationships
- Swift Charts for data visualization
- Standard iOS app bundle identifier: `com.stevolution.MoneyMash`
- Development team ID: 5GD9WZ2Y4S
- SwiftUI previews enabled for development

## Design System

### **Card-Based UI Pattern**
- All major components use gray cards (`Color(.systemGray6)`) on white backgrounds
- 12pt corner radius with subtle shadows for depth
- Consistent 16pt spacing between major sections
- Horizontal padding for proper margins

### **Account Types & Icons**
- Each account type has dedicated SF Symbol icons
- Color-coded trend indicators (red for debt accounts, blue/green for assets)
- Smart debt logic with contextual messaging (e.g., "Debt reduced by £X")

### **Navigation & Interaction**
- Unified scrolling experience across all views
- NavigationLink cards maintain button styling
- Consistent toolbar design with app title and add button

## Development Notes

- The project targets both iPhone and iPad (TARGETED_DEVICE_FAMILY = "1,2")
- SwiftUI previews are enabled in the build configuration
- Asset symbol extensions are automatically generated
- The app supports all standard iOS orientations for both iPhone and iPad
- Sample data is automatically populated in debug builds if database is empty
- All currency formatting uses GBP with proper decimal handling