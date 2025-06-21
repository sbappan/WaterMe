import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var reminderInterval = 60 // in minutes
    
    private let persistenceService = PersistenceService()
    private let notificationManager = NotificationManager()

    var body: some View {
        NavigationView {
            VStack {
                ScheduleFormView(
                    startTime: $startTime,
                    endTime: $endTime,
                    reminderInterval: $reminderInterval
                )
                
                Button(action: {
                    let schedule = Schedule(
                        startTime: startTime,
                        endTime: endTime,
                        reminderInterval: TimeInterval(reminderInterval * 60), // convert minutes to seconds
                        followUpInterval: 5 * 60 // 5 minutes in seconds
                    )
                    persistenceService.saveSchedule(schedule)
                    
                    notificationManager.requestAuthorization { granted in
                        if granted {
                            self.notificationManager.scheduleReminders()
                        }
                        print("Notification permission granted: \(granted)")
                        isPresented = false
                    }
                }) {
                    Text("Save and Continue")
                }
                .padding()
            }
            .navigationTitle("Setup Reminders")
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isPresented: .constant(true))
    }
} 