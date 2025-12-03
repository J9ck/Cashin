# Cashin'
A minimalist daily financial tracker for iOS.

## Overview
Cashin' is a SwiftUI-based iOS app that helps you track your daily financial balance. The app features a clean, minimalist design with dynamic theming that responds to your net balance.

## Features
- 📊 **Daily Balance Tracking**: Large, animated display of your net daily balance
- 🎨 **Dynamic Theming**: Background color changes based on balance (green for positive, red for negative)
- ⚡ **Quick Add Buttons**: Instantly add common income/expense amounts
- 📝 **Custom Entries**: Add detailed transactions with categories
- 💰 **Earnings Tracking**: Track income and expenses over time with detailed analytics
- 📈 **7-Day History**: View analytics with charts and daily breakdowns
- 🔔 **Daily Reminders**: Smart notifications at 8 PM based on your balance
- ♻️ **Automatic Reset**: Daily reset with historical data archiving

## Technical Stack
- **Framework**: SwiftUI
- **Data Persistence**: SwiftData
- **Charts**: Swift Charts
- **Notifications**: UserNotifications
- **Minimum iOS Version**: 17.0
- **Development Tool**: Xcode 15+

## Project Structure
```
Cashin/
├── CashinApp.swift                    # @main entry point
├── Models/
│   ├── Transaction.swift              # Transaction @Model
│   ├── DailySummary.swift             # DailySummary @Model  
│   ├── AppSettings.swift              # AppSettings @Model
│   ├── Earnings.swift                 # Earnings tracking @Model
│   └── TransactionType.swift          # TransactionType enum
├── Views/
│   ├── ContentView.swift              # Main dashboard
│   ├── AddTransactionView.swift       # Add entry sheet
│   ├── HistoryView.swift              # Analytics/chart view
│   ├── EarningsView.swift             # Earnings tracking view
│   └── Components/
│       ├── QuickAddButton.swift       # Reusable quick add button
│       └── TransactionRow.swift       # Transaction list row
├── Managers/
│   ├── NotificationManager.swift      # Notification scheduling
│   ├── DayResetManager.swift          # Smart day reset logic
│   ├── EarningsManager.swift          # Earnings calculations
│   └── AnalyticsManager.swift         # App analytics tracking
├── Extensions/
│   └── Date+Extensions.swift          # Date helper extensions
├── Resources/
│   └── Assets.xcassets/               # App icons, colors
├── Info.plist                         # Configuration & permissions
├── Cashin.entitlements                # App capabilities
└── APP_STORE_SETUP.md                 # App Store deployment guide
```

## Getting Started

### Prerequisites
- macOS with Xcode 15.0 or later
- iOS 17.0+ Simulator or device

### Building the Project
Since this is a Swift Package Manager or standalone Swift files project, to build:

1. Clone the repository:
   ```bash
   git clone https://github.com/J9ck/Cashin.git
   cd Cashin
   ```

2. Open in Xcode:
   - Create a new iOS App project in Xcode
   - Replace the default files with the files from this repository
   - Ensure the project settings match:
     - Deployment Target: iOS 17.0
     - Bundle Identifier: com.yourcompany.cashin
     - Display Name: Cashin'

3. Build and run on simulator or device

### Running on Device
Make sure to configure signing in Xcode with your Apple Developer account.

## App Store Deployment

For detailed instructions on preparing the app for App Store submission, including:
- Code signing and provisioning profiles
- App Store Connect configuration
- Privacy policy requirements
- Analytics setup (Firebase or Apple Analytics)
- Build and archive process
- Review guidelines compliance

Please refer to [APP_STORE_SETUP.md](APP_STORE_SETUP.md)

## Usage

### Main Dashboard
- View your current daily balance at the top
- Use quick-add buttons for common amounts ($5, $10, $20)
- Tap "Add Entry" for custom transactions
- Swipe left on transactions to delete
- Tap "History" to view 7-day analytics

### Adding Transactions
1. Tap "Add Entry" or use quick-add buttons
2. Select Income or Expense
3. Enter the amount
4. Choose a category
5. Tap "Save"

### Viewing Earnings
1. Tap "Earnings" on the main dashboard
2. View your net earnings for different periods (Week/Month/Lifetime)
3. See income vs expenses breakdown
4. Analyze earnings by category

### Categories
**Income**: Work, Freelance, Gifts, Bonus, Other
**Expense**: Coffee, Groceries, Food, Transport, Entertainment, Shopping

### Notifications
The app will request notification permissions on first launch and send daily reminders at 8 PM with context-aware messages based on your balance.

## Code Quality
- Uses `// MARK: -` comments for organization
- Follows Apple's Swift naming conventions
- Includes accessibility labels for VoiceOver
- Proper error handling with try? for SwiftData operations

## Screenshots

> 📸 Coming soon! Screenshots will showcase:
> - Main dashboard with balance display
> - Quick-add transaction buttons
> - Add transaction form
> - 7-day history and analytics charts
> - Notification examples

## Demo Video

> 🎥 Video demonstration coming soon!
> 
> The demo will show:
> - Adding income and expenses
> - Using quick-add buttons
> - Viewing daily history
> - Notification interactions

## Analytics and Monitoring

### Firebase Integration (Optional)

To integrate Firebase for analytics and crash reporting:

1. **Create a Firebase project** at [Firebase Console](https://console.firebase.google.com/)
2. **Add your iOS app** to the Firebase project
3. **Download `GoogleService-Info.plist`** and add it to your Xcode project
4. **Install Firebase SDK** using Swift Package Manager:
   - In Xcode: File → Add Package Dependencies
   - URL: `https://github.com/firebase/firebase-ios-sdk`
   - Add packages: FirebaseAnalytics, FirebaseCrashlytics
5. **Initialize Firebase** in `CashinApp.swift`:
   ```swift
   import Firebase
   
   @main
   struct CashinApp: App {
       init() {
           FirebaseApp.configure()
       }
       // ... rest of code
   }
   ```

### Apple App Analytics

To use Apple's built-in analytics:

1. **Enable App Analytics** in App Store Connect
2. **Review analytics data** in App Store Connect → Analytics
3. **No code changes required** - automatically tracked for App Store builds

## Testing

### Unit Tests

Unit tests should be created in a `CashinTests` folder to test:
- Transaction model creation and validation
- DailySummary calculations
- Date extension helpers
- NotificationManager logic
- DayResetManager logic

Example test structure:
```swift
import XCTest
@testable import Cashin

final class TransactionTests: XCTestCase {
    func testTransactionCreation() {
        // Test implementation
    }
}
```

### UI Tests

UI tests should be created in a `CashinUITests` folder to test:
- Main balance display
- Adding transactions via UI
- Quick-add button functionality
- History view navigation
- Swipe-to-delete interactions

### Running Tests

Tests can be run via:
- **Xcode**: Product → Test (⌘U)
- **Command line**: `xcodebuild test -project Cashin.xcodeproj -scheme Cashin -destination 'platform=iOS Simulator,name=iPhone 15'`
- **GitHub Actions**: Automatically on push/PR (see `.github/workflows/ios-ci.yml`)

## Continuous Integration

This project uses GitHub Actions for CI/CD:
- **Automated builds** on push and pull requests
- **Automated testing** when tests are implemented
- **SwiftLint** code quality checks
- **Workflow**: `.github/workflows/ios-ci.yml`

## Repository Guidelines

### Branch Protection

For production repositories, enable branch protection rules:
1. Go to **Settings → Branches** in GitHub
2. Add rule for `main` branch:
   - Require pull request reviews before merging
   - Require status checks to pass before merging
   - Require branches to be up to date before merging
   - Include administrators

### Dependabot

This repository includes **Dependabot configuration** (`.github/dependabot.yml`) to:
- Monitor Swift Package Manager dependencies
- Monitor GitHub Actions versions
- Automatically create PRs for updates
- Schedule: Weekly on Mondays

### GitHub Discussions

Enable GitHub Discussions for community interaction:
1. Go to **Settings → General** in GitHub
2. Scroll to **Features**
3. Check **Discussions**
4. Configure categories:
   - 📢 Announcements
   - 💡 Ideas & Feature Requests
   - 🙋 Q&A
   - 🐛 Bug Reports
   - 💬 General Discussion

## License

MIT License - See [LICENSE](LICENSE) file for details.

Copyright (c) 2025 J9ck

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on:
- Reporting bugs
- Suggesting enhancements
- Submitting pull requests
- Code style and standards
- Development setup

For major changes, please open an issue first to discuss what you would like to change.
