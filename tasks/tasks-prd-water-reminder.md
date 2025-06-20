## Relevant Files

- `WaterMe/WaterMeApp.swift` - The main entry point for the SwiftUI application.
- `WaterMe/ContentView.swift` - The main view that will display progress and navigate to settings.
- `WaterMe/Views/OnboardingView.swift` - The view for the initial setup of reminder preferences.
- `WaterMe/Views/SettingsView.swift` - The view for editing the reminder schedule after the initial setup.
- `WaterMe/Services/NotificationManager.swift` - Handles requesting permissions and scheduling all local notifications.
- `WaterMe/Services/PersistenceService.swift` - Manages saving and retrieving user settings and daily progress using `UserDefaults`.
- `WaterMeTests/NotificationManagerTests.swift` - Unit tests for the `NotificationManager`.
- `WaterMeTests/PersistenceServiceTests.swift` - Unit tests for the `PersistenceService`.

### Notes

- Unit tests should be placed in the `WaterMeTests` target.
- Use Xcode's testing framework to run tests for specific files or the entire suite.

## Tasks

- [x] 1.0 Project Setup & Basic UI Shell
  - [x] 1.1 Create a new SwiftUI project named `WaterReminder` in Xcode.
  - [x] 1.2 Set up the basic folder structure: `Views`, `Services`, `Models`.
  - [x] 1.3 Implement a basic `NavigationView` in `ContentView.swift` that can display the main progress screen and has a button to navigate to `SettingsView`.

- [x] 2.0 Onboarding and Reminder Configuration
  - [x] 2.1 Create the UI for `OnboardingView.swift` with `DatePicker` for start/end times and `TextField` or `Stepper` for intervals.
  - [x] 2.2 In `PersistenceService.swift`, implement functions to save and load the schedule (start time, end time, interval, follow-up interval).
  - [x] 2.3 Implement logic to show `OnboardingView` as a modal on the first app launch.
  - [x] 2.4 Create `SettingsView.swift` by reusing the UI from `OnboardingView` to allow users to modify their schedule.
  - [x] 2.5 Ensure that any changes in `SettingsView` are saved using `PersistenceService`.

- [ ] 3.0 Implement Notification System
  - [ ] 3.1 In `NotificationManager.swift`, add a function to request user permission for notifications. Call this after onboarding.
  - [ ] 3.2 Implement a `scheduleReminders()` function that reads the schedule from `PersistenceService`.
  - [ ] 3.3 Calculate and schedule the primary local notifications for the day, ensuring they don't fire outside the start/end times.
  - [ ] 3.4 Add a notification action button "I Drank" to the primary reminder.
  - [ ] 3.5 Implement logic to schedule a follow-up reminder if the primary one is missed.
  - [ ] 3.6 Create a `cancelAllNotifications()` function to be called when the user updates their schedule in `SettingsView`.

- [ ] 4.0 Develop Main Screen for Progress Tracking
  - [ ] 4.1 Design the UI in `ContentView.swift` to show progress (e.g., "3/8 reminders completed").
  - [ ] 4.2 In `PersistenceService.swift`, add functions to save, load, and reset the daily completion count.
  - [ ] 4.3 Implement logic to calculate the total number of reminders based on the user's schedule.
  - [ ] 4.4 Ensure the `ContentView` fetches and displays the latest progress from `PersistenceService` when it appears.

- [ ] 5.0 Implement Reminder Confirmation Logic
  - [ ] 5.1 In `NotificationManager.swift`, implement the handler for the "I Drank" notification action.
  - [ ] 5.2 When the action is triggered, use `PersistenceService` to increment the daily completion count.
  - [ ] 5.3 Upon confirmation, cancel any pending follow-up reminders for the current interval.
  - [ ] 5.4 Ensure the main `ContentView` updates its UI to reflect the new progress when the app is opened. 