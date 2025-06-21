import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var reminderInterval = 60 // in minutes
    
    private let persistenceService = PersistenceService()

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
                        reminderInterval: TimeInterval(reminderInterval * 60) // convert minutes to seconds
                    )
                    persistenceService.saveSchedule(schedule)
                    isPresented = false
                }) {
                    Text("Save and Continue")
                }
                .padding()
            }
            .navigationTitle("Setup Schedule")
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isPresented: .constant(true))
    }
} 