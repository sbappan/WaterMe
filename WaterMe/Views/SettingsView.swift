import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var reminderInterval = 60 // in minutes

    private let persistenceService = PersistenceService()

    var body: some View {
        VStack {
            ScheduleFormView(
                startTime: $startTime,
                endTime: $endTime,
                reminderInterval: $reminderInterval
            )
            
            HStack(spacing: 16) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                .padding()
                
                Button(action: {
                    let schedule = Schedule(
                        startTime: startTime,
                        endTime: endTime,
                        reminderInterval: TimeInterval(reminderInterval * 60) // convert minutes to seconds
                    )
                    persistenceService.saveSchedule(schedule)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Changes")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Settings")
        .onAppear(perform: loadSchedule)
    }

    private func loadSchedule() {
        if let schedule = persistenceService.loadSchedule() {
            startTime = schedule.startTime
            endTime = schedule.endTime
            reminderInterval = Int(schedule.reminderInterval / 60) // convert seconds to minutes
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