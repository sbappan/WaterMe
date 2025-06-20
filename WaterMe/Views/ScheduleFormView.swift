import SwiftUI

struct ScheduleFormView: View {
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var reminderInterval: Double

    var body: some View {
        Form {
            Section(header: Text("When should we remind you?")) {
                DatePicker("Start time", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("End time", selection: $endTime, displayedComponents: .hourAndMinute)
            }

            Section(header: Text("How often?")) {
                Stepper(value: $reminderInterval, in: 0.5...4, step: 0.5) {
                    Text("\(reminderInterval, specifier: "%.1f") hours")
                }
            }
        }
    }
} 