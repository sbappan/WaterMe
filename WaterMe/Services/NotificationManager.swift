import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    private let persistenceService = PersistenceService()

    static let reminderCategoryIdentifier = "WATER_REMINDER"

    override init() {
        super.init()
        notificationCenter.delegate = self
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
            if granted {
                self.registerNotificationCategories()
            }
            completion(granted)
        }
    }

    private func registerNotificationCategories() {
        let iDrankAction = UNNotificationAction(
            identifier: "I_DRANK_ACTION",
            title: "I Drank",
            options: [.foreground]
        )

        let reminderCategory = UNNotificationCategory(
            identifier: Self.reminderCategoryIdentifier,
            actions: [iDrankAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )

        notificationCenter.setNotificationCategories([reminderCategory])
    }

    func scheduleReminders() {
        guard let schedule = persistenceService.loadSchedule() else {
            print("No schedule found. Cannot schedule reminders.")
            return
        }
        
        print("Scheduling reminders with schedule: \(schedule)")
        cancelAllNotifications()

        let calendar = Calendar.current
        var currentTime = schedule.startTime
        let endTime = schedule.endTime

        while currentTime <= endTime {
            let primaryIdentifier = UUID().uuidString
            
            // Schedule Primary Reminder
            let content = UNMutableNotificationContent()
            content.title = "Time to drink water!"
            content.body = "Stay hydrated to keep your energy up."
            content.sound = .default
            content.categoryIdentifier = Self.reminderCategoryIdentifier
            
            let triggerDate = calendar.dateComponents([.hour, .minute], from: currentTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

            let request = UNNotificationRequest(
                identifier: primaryIdentifier,
                content: content,
                trigger: trigger
            )

            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling primary notification: \(error)")
                }
            }

            // Schedule Follow-up Reminder
            let followUpTime = currentTime.addingTimeInterval(schedule.followUpInterval)
            if followUpTime <= endTime {
                let followUpContent = UNMutableNotificationContent()
                followUpContent.title = "Gentle Reminder"
                followUpContent.body = "Have you had a glass of water yet?"
                followUpContent.sound = .default
                followUpContent.categoryIdentifier = Self.reminderCategoryIdentifier

                let followUpTriggerDate = calendar.dateComponents([.hour, .minute, .second], from: followUpTime)
                let followUpTrigger = UNCalendarNotificationTrigger(dateMatching: followUpTriggerDate, repeats: true)

                let followUpRequest = UNNotificationRequest(
                    identifier: "\(primaryIdentifier)_followup",
                    content: followUpContent,
                    trigger: followUpTrigger
                )

                notificationCenter.add(followUpRequest) { error in
                    if let error = error {
                        print("Error scheduling follow-up notification: \(error)")
                    }
                }
            }

            currentTime = calendar.date(byAdding: .second, value: Int(schedule.reminderInterval), to: currentTime)!
        }
    }

    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        let requestIdentifier = response.notification.request.identifier

        if identifier == "I_DRANK_ACTION" {
            handleDrinkAction(for: requestIdentifier)
        }

        completionHandler()
    }
    
    private func handleDrinkAction(for notificationIdentifier: String) {
        print("'I Drank' action handled for notification: \(notificationIdentifier)")
        persistenceService.incrementCompletionCount()
        
        // Cancel the follow-up reminder
        let followUpIdentifier: String
        if notificationIdentifier.hasSuffix("_followup") {
            followUpIdentifier = notificationIdentifier
        } else {
            followUpIdentifier = "\(notificationIdentifier)_followup"
        }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [followUpIdentifier])
    }
    
    func getNextNotificationDate(completion: @escaping (Date?) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            let nextRequest = requests
                .compactMap { request -> Date? in
                    guard let trigger = request.trigger as? UNCalendarNotificationTrigger,
                          let nextTriggerDate = trigger.nextTriggerDate() else {
                        return nil
                    }
                    return nextTriggerDate
                }
                .min()
            
            DispatchQueue.main.async {
                completion(nextRequest)
            }
        }
    }
} 