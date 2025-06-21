//
//  ContentView.swift
//  WaterMe
//
//  Created by Santhosh Appan on 2025-06-20.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isShowingOnboarding = false
    @State private var isShowingSettings = false
    @State private var completedReminders = 0
    @State private var isStarted = false
    @State private var reminderInterval = 60 * 30; // seconds
    @State private var timer: Timer?
    @State private var timeRemaining = 0
    
    private let persistenceService = PersistenceService()

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                if isStarted {
                    VStack {
                        Text("Next reminder in")
                            .font(.subheadline)
                        Text(formatTime(seconds: timeRemaining))
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                    }
                }
                
                Button(action: {
                    isStarted.toggle()
                }) {
                    Text(isStarted ? "Stop" : "Start")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isStarted ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .onChange(of: isStarted) { started in
                    if started {
                        startTimer()
                    } else {
                        stopTimer()
                    }
                }
                
                VStack {
                    Text("Today's Progress")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("\(completedReminders) glasses")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                    completedReminders += 1
                    persistenceService.saveProgress(count: completedReminders)
                }) {
                    Text("I drank a glass!")
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: {
                    completedReminders = 0
                    persistenceService.saveProgress(count: 0)
                }) {
                    Text("Reset")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Water Me")
            .toolbar {
                Button(action: {
                    isShowingSettings = true
                }) {
                    Image(systemName: "gear")
                }
            }
        }
        .onAppear {
            if persistenceService.loadProgress() == nil {
                isShowingOnboarding = true
            } else {
                setupView()
            }
        }
        .sheet(isPresented: $isShowingSettings, onDismiss: {
            setupView()
        }) {
            NavigationView {
                SettingsView()
            }
        }
        .sheet(isPresented: $isShowingOnboarding, onDismiss: {
            persistenceService.saveProgress(count: 0)
            setupView()
        }) {
            OnboardingView(isPresented: $isShowingOnboarding)
        }
    }

    private func setupView() {
        // Load progress for the day
        persistenceService.resetCompletionCountIfNeeded()
        
        if let progress = persistenceService.loadProgress() {
            completedReminders = progress.count
        }
    }

    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startTimer() {
        timeRemaining = reminderInterval
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                let currentHour = Calendar.current.component(.hour, from: Date())
                if currentHour < 21 {
                    AudioServicesPlaySystemSound(1035)
                }
                self.timeRemaining = self.reminderInterval
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        timeRemaining = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
