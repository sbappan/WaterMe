import SwiftUI

struct ScheduleFormView: View {
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var reminderInterval: Int

    private let reminderIntervals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 30, 45, 60, 90, 120]

    var body: some View {
        Form {
            Section(header: Text("When should we remind you?")) {
                DatePicker("Start time", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("End time", selection: $endTime, displayedComponents: .hourAndMinute)
            }

            Section(header: Text("How often?")) {
                Picker("Remind me every", selection: $reminderInterval) {
                    ForEach(reminderIntervals, id: \.self) { interval in
                        Text("\(interval) minutes").tag(interval)
                    }
                }
            }
        }
    }
} 