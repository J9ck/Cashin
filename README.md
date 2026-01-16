# Cashin'
A minimalist daily financial tracker for iOS.

## Overview
Cashin' is a SwiftUI-based iOS app that helps you track your daily financial balance. The app features a clean, minimalist design with dynamic theming that responds to your net balance.

## Features
- 📊 **Daily Balance Tracking**: Large, animated display of your net daily balance
- 🎨 **Dynamic Theming**: Background color changes based on balance (green for positive, red for negative)
- ⚡ **Quick Add Buttons**: Instantly add common income/expense amounts
- 📝 **Custom Entries**: Add detailed transactions with categories
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
│   └── TransactionType.swift          # TransactionType enum
├── Views/
│   ├── ContentView.swift              # Main dashboard
│   ├── AddTransactionView.swift       # Add entry sheet
│   ├── HistoryView.swift              # Analytics/chart view
│   └── Components/
│       ├── QuickAddButton.swift       # Reusable quick add button
│       └── TransactionRow.swift       # Transaction list row
├── Managers/
│   ├── NotificationManager.swift      # Notification scheduling
│   └── DayResetManager.swift          # Smart day reset logic
├── Extensions/
│   └── Date+Extensions.swift          # Date helper extensions
├── Resources/
│   └── Assets.xcassets/               # App icons, colors
└── Info.plist                         # Configuration & permissions
```

## Getting Started

### Prerequisites
- macOS with Xcode 15.0 or later
- iOS 17.0+ Simulator or device

### Building the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/J9ck/Cashin.git
   cd Cashin
   ```

2. Open the project in Xcode:
   ```bash
   open Cashin.xcodeproj
   ```
   Or double-click `Cashin.xcodeproj` in Finder.

3. Configure code signing:
   - Select the project in Xcode
   - Go to "Signing & Capabilities"
   - Select your Team in the "Signing" section

4. Build and run:
   - Select a simulator or connected device
   - Press ⌘R or click the Run button

### Running on Device
Make sure to configure signing in Xcode with your Apple Developer account. The project is pre-configured with:
- Deployment Target: iOS 17.0
- Bundle Identifier: com.cashin.app
- Display Name: Cashin'

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

## License
MIT License - See LICENSE file for details

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.
