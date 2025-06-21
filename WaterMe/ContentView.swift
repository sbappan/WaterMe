//
//  ContentView.swift
//  WaterMe
//
//  Created by Santhosh Appan on 2025-06-20.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingOnboarding = false
    @State private var completedReminders = 0
    @State private var totalReminders = 0
    @State private var timeRemaining: String?
    @State private var timer: Timer?
    
    private let persistenceService = PersistenceService()
    private let notificationManager = NotificationManager()

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                VStack {
                    Text("Today's Progress")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("\(completedReminders) of \(totalReminders) glasses")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                
                ProgressView(value: Double(completedReminders), total: Double(totalReminders))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(x: 1, y: 4, anchor: .center)
                    .padding(.horizontal)
                
                if let timeRemaining = timeRemaining {
                    Text("Next reminder in: \(timeRemaining)")
                        .font(.headline)
                }

                Spacer()
                
                NavigationLink(destination: SettingsView()) {
                     Text("Edit Schedule")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Water Me")
            .navigationBarHidden(true)
        }
        .onAppear(perform: {
            if persistenceService.loadSchedule() == nil {
                isShowingOnboarding = true
            } else {
                setupView()
                setupAndStartTimer()
            }
        })
        .onDisappear {
            timer?.invalidate()
        }
        .sheet(isPresented: $isShowingOnboarding, onDismiss: {
            setupView()
            setupAndStartTimer()
        }) {
            OnboardingView(isPresented: $isShowingOnboarding)
        }
    }
    
    private func setupAndStartTimer() {
        timer?.invalidate()
        
        notificationManager.getNextNotificationDate { nextDate in
            guard let nextDate = nextDate else {
                self.timeRemaining = "Not scheduled"
                return
            }
            
            self.updateRemainingTime(nextDate: nextDate)
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.updateRemainingTime(nextDate: nextDate)
            }
        }
    }
    
    private func updateRemainingTime(nextDate: Date) {
        let remaining = nextDate.timeIntervalSince(Date())
        if remaining > 0 {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .abbreviated
            self.timeRemaining = formatter.string(from: remaining)
        } else {
            self.timeRemaining = "Now!"
            // Once the timer is expired, we should look for the *next* one.
            // Re-scheduling the timer check.
            self.timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.setupAndStartTimer()
            }
        }
    }

    private func setupView() {
        // Load progress for the day
        persistenceService.resetCompletionCountIfNeeded()
        
        if let progress = persistenceService.loadProgress() {
            completedReminders = progress.count
        }
        
        if let schedule = persistenceService.loadSchedule() {
            totalReminders = schedule.totalReminders
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
