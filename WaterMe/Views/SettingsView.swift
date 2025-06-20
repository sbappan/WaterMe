import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var reminderInterval = 1.0 // in hours

    private let persistenceService = PersistenceService()
    private let notificationManager = NotificationManager()

    var body: some View {
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
                    reminderInterval: reminderInterval * 3600, // convert hours to seconds
                    followUpInterval: 15 * 60 // 15 minutes in seconds
                )
                persistenceService.saveSchedule(schedule)
                notificationManager.scheduleReminders()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Changes")
            }
            .padding()
        }
        .navigationTitle("Settings")
        .onAppear(perform: loadSchedule)
    }

    private func loadSchedule() {
        if let schedule = persistenceService.loadSchedule() {
            startTime = schedule.startTime
            endTime = schedule.endTime
            reminderInterval = schedule.reminderInterval / 3600 // convert seconds to hours
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
} 