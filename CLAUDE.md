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
│   ├── Portfolio/             # Portfolio overview and management
│   │   ├── PortfolioView.swift      # Main portfolio screen with summary and account cards
│   │   └── AddAccountView.swift     # New account creation form
│   └── Account/               # Individual account details
│       └── AccountDetailView.swift  # Account detail screen with charts and history
├── Components/                 # Reusable UI components organized by feature
│   ├── Portfolio/             # Portfolio-related components
│   │   ├── PortfolioSummaryCard.swift    # Net worth summary with change indicators
│   │   ├── PortfolioOptionsModal.swift   # Pension/mortgage toggle controls
│   │   ├── FinancialAccountCard.swift    # Individual account display card
│   │   └── ChangeIndicator.swift         # Reusable change display component
│   └── Account/               # Account detail components
│       ├── AccountSummaryCard.swift      # Account header with balance info
│       ├── UpdateBalanceCard.swift       # Balance update form
│       ├── AccountChart.swift            # Swift Charts with dynamic scaling
│       └── BalanceHistoryCard.swift      # Balance history display
└── Resources/                  # Assets and resources
    └── Assets.xcassets/       # App icons, colors, and visual assets
```

### **App Structure & Naming Conventions**

**Portfolio**: The main overview screen showing all financial accounts
- **PortfolioView**: Main screen with summary and account cards
- **PortfolioSummaryCard**: Net worth summary with pension/mortgage toggles
- **FinancialAccountCard**: Individual account preview cards

**Account**: Individual account detail functionality
- **AccountDetailView**: Detailed view for a single account
- **AccountSummaryCard**: Account header with balance and last update
- **UpdateBalanceCard**: Form for updating account balances
- **AccountChart**: Swift Charts visualization of balance history
- **BalanceHistoryCard**: List of historical balance updates

### **Data Models (SwiftData)**
- **FinancialAccount**: Core account model with balance tracking and performance metrics
- **BalanceUpdate**: Individual balance entries with timestamps
- **AccountType**: Enum covering all financial account types (savings, investments, debt, etc.)
- **SampleData**: Provides realistic sample data for development and testing

### **Key Features**
- Unified scrolling design throughout the app
- Card-based UI with gray cards on white background
- Smart debt vs asset account handling with contextual trend indicators
- Update-based change calculations showing differences since last update
- Interactive charts with dynamic Y-axis scaling and data-driven labeling
- Net worth calculation with configurable pension/mortgage inclusion
- Portfolio-wide change tracking since last account update
- Dynamic SwiftCharts visualization with gradient fills and data points

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

## SwiftUI & SwiftData Best Practices

**CRITICAL**: This project strictly adheres to Apple's recommended best practices for SwiftUI and SwiftData. Only deviate from these practices when there is a compelling technical reason and document the rationale.

### **SwiftUI Best Practices**
- **State Management**: Use `@State` for local component state, `@Binding` for shared state, `@Query` for SwiftData queries
- **Component Architecture**: Follow single responsibility principle with focused, reusable components
- **List Operations**: Use `ForEach` with SwiftUI's built-in `swipeActions` for delete functionality
- **Navigation**: Use `NavigationStack` and `NavigationLink` for standard iOS navigation patterns
- **Animations**: Wrap state changes with `withAnimation` for smooth transitions
- **Modifiers**: Apply view modifiers in logical order (content → layout → styling → behavior)

### **SwiftData Best Practices**
- **Model Relationships**: Use `@Relationship` with appropriate `deleteRule` (cascade for dependent data)
- **Data Operations**: Use `modelContext.delete()` and `modelContext.save()` for data persistence
- **Query Management**: Leverage `@Query` for automatic UI updates when data changes
- **Error Handling**: Always wrap save operations in do-catch blocks
- **Performance**: Use computed properties for derived data rather than stored duplicates

### **Implemented Patterns**
- **Cascade Deletion**: FinancialAccount → BalanceUpdate relationship with `.cascade` delete rule
- **Swipe-to-Delete**: Standard iOS pattern with confirmation dialog for destructive actions
- **Modal Presentations**: Use `.confirmationDialog` for confirmations, custom overlays for contextual options
- **Binding Communication**: Pass state between parent and child components using `@Binding`

### **Data Integrity**
- All financial calculations use `Decimal` for precision
- Date handling uses proper `Calendar` and `DateFormatter` patterns
- SwiftData relationships ensure referential integrity
- Sample data provides realistic test scenarios

## Change Calculation System

### **Update-Based Change Logic**
The app implements a sophisticated change tracking system that shows meaningful, update-based changes rather than arbitrary monthly calculations:

**Individual Account Changes**: 
- Show change since that specific account's last update
- Uses `previousUpdateBalance` property to find the second-most-recent balance
- Calculated via `updateChange` and `updateChangePercentage` properties

**Portfolio Summary Changes**:
- Shows changes since the last time ANY account was updated across the entire portfolio
- Finds the most recent and second-most-recent update dates across all accounts
- Calculates historical portfolio totals at both time points for comparison

### **FinancialAccount Model Properties**
- `previousUpdateBalance`: Second-most-recent balance for the account
- `updateChange`: Decimal change since last update
- `updateChangePercentage`: Percentage change since last update
- `formattedUpdateChange`: User-friendly change display with proper debt logic
- `formattedUpdateChangePercentage`: Formatted percentage with +/- prefix
- `isPositiveTrend`: Smart logic (debt reduction = positive, asset growth = positive)
- `trendDirection`: Appropriate SF Symbol arrow direction

### **ChangeIndicator Component**
Reusable UI component that displays:
- Contextual color coding (green for positive, red for negative)
- Appropriate arrow directions with SF Symbols
- Handles zero changes with "No change" display
- Supports both debt and asset account logic

## SwiftCharts Integration

### **Dynamic Chart Features**
- **Dynamic Y-Axis Scaling**: Automatically calculates optimal Y-axis range based on data, avoiding unnecessary zero baselines
- **Data-Driven X-Axis Labels**: Smart thinning algorithm shows actual data points rather than arbitrary calendar intervals
- **Custom Domain Calculation**: Adds 10% padding above and below data range for better visualization
- **Smart Baseline Logic**: Different gradient fill logic for debt vs asset accounts

### **Chart Visual Design**
- Subtle gradient fills (15% opacity) that don't overwhelm the data
- Thin connecting lines (1pt width) with small data point dots
- Proper gradient positioning to avoid covering X-axis labels
- Years always displayed for temporal context regardless of time span

### **Sample Data for Testing**
Comprehensive sample data spanning:
- 6 weeks to 7 years of history across 10 different accounts
- Various account types (savings, investments, pensions, debt, foreign currency)
- Realistic growth patterns, volatility, and debt reduction scenarios
- Tests all chart labeling and scaling scenarios

## Development Notes

- The project targets both iPhone and iPad (TARGETED_DEVICE_FAMILY = "1,2")
- SwiftUI previews are enabled in the build configuration
- Asset symbol extensions are automatically generated
- The app supports all standard iOS orientations for both iPhone and iPad
- Sample data is automatically populated in debug builds if database is empty
- All currency formatting uses GBP with proper decimal handling