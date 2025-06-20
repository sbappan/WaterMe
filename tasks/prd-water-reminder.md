# Product Requirements Document: Water Reminder App

## 1. Introduction/Overview
This document outlines the requirements for a simple iOS application designed to remind users to drink water at regular intervals. The primary goal is to provide a discreet and persistent reminder system that helps users stay hydrated throughout the day. The app will send notifications at user-defined times and will continue to send follow-up reminders at shorter intervals until the user confirms they have had a drink.

## 2. Goals
*   To provide a simple, set-and-forget tool for hydration reminders.
*   To ensure users do not miss reminders through persistent follow-up notifications.
*   To offer a basic visualization of daily progress to encourage consistency.

## 3. User Stories
*   **As a user**, I want to set a start time, end time, and frequency for my water reminders so that I am reminded only during my waking hours.
*   **As a user**, I want to receive a discreet notification (a quiet sound and alert) when it's time to drink water so that I am not disturbed or distracted.
*   **As a user**, if I miss a reminder, I want to be reminded again more frequently until I confirm I've had water, so I don't forget.
*   **As a user**, I want to be able to configure the interval for these follow-up reminders to suit my preference.
*   **As a user**, I want to quickly confirm that I've had water with a single tap on the notification.
*   **As a user**, I want to see a simple summary of how many times I've successfully drunk water today to track my consistency.

## 4. Functional Requirements
1.  **Onboarding & Setup**
    1.1. On first launch, the app must guide the user to set up their reminder schedule.
    1.2. The user must be able to set a "Start Time" for the daily reminders.
    1.3. The user must be able to set an "End Time" for the daily reminders.
    1.4. The user must be able to set a primary reminder "Interval" in minutes (e.g., 60 minutes).
    1.5. The user must be able to configure the "Follow-up Interval" in minutes (e.g., 15 minutes) for missed reminders.
    1.6. The app must request permission to send notifications.

2.  **Notifications**
    2.1. The system must send a local notification at the specified interval between the start and end times.
    2.2. The notification must use a standard, quiet sound.
    2.3. The notification must include a "I Drank" action button to confirm water intake.
    2.4. If a notification is not acted upon (i.e., the "I Drank" button is not tapped), the system must trigger follow-up notifications at the user-configured "Follow-up Interval".
    2.5. Follow-up reminders must stop once the user confirms by tapping "I Drank".
    2.6. No notifications should be sent outside the user-defined start and end times.

3.  **Main Screen**
    3.1. The main screen must display the user's daily progress.
    3.2. Progress should be shown as a simple count (e.g., "3 out of 8 reminders completed"). The total number of reminders is calculated from the user's schedule.
    3.3. The app must provide a way for the user to edit their reminder schedule (start/end time, interval, follow-up interval).

4.  **Confirmation**
    4.1. Tapping the "I Drank" button on a notification will mark that interval's reminder as complete.
    4.2. The daily progress on the main screen must update immediately after a confirmation.

## 5. Non-Goals (Out of Scope)
*   No integration with Apple Health or other fitness platforms.
*   No social sharing features.
*   No tracking of different beverage types (only water).
*   No logging of specific water quantities (e.g., ml or oz). Confirmation is sufficient.
*   No complex historical data views (e.g., weekly/monthly charts).

## 6. Design Considerations
*   The UI should be clean, simple, and intuitive.
*   Use standard iOS UI components to ensure a familiar user experience.
*   A single screen for settings and a single screen for the daily view is sufficient for the initial version.

## 7. Success Metrics
*   High user retention rate after the first week.
*   Positive App Store reviews mentioning the app's simplicity and effectiveness.
*   High percentage of daily active users successfully completing their daily reminders.

## 8. Open Questions
*   Should the app icon have a badge to show the number of missed reminders?
*   What should be the default values for the reminder interval and follow-up interval?
*   Should the "I Drank" confirmation reset the main interval timer, or should the next reminder still arrive at its originally scheduled time? 