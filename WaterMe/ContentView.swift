//
//  ContentView.swift
//  WaterMe
//
//  Created by Santhosh Appan on 2025-06-20.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingOnboarding = false
    @State private var isShowingSettings = false
    @State private var completedReminders = 0
    @State private var totalReminders = 0
    
    private let persistenceService = PersistenceService()

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
                
                Spacer()
                
                Button(action: {
                    isShowingSettings = true
                }) {
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
            }
        })
        .sheet(isPresented: $isShowingSettings, onDismiss: {
            setupView()
        }) {
            NavigationView {
                SettingsView()
            }
        }
        .sheet(isPresented: $isShowingOnboarding, onDismiss: {
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
