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
        .onAppear(perform: setupView)
        .sheet(isPresented: $isShowingOnboarding) {
            OnboardingView(isPresented: $isShowingOnboarding)
        }
    }
    
    private func setupView() {
        // Check for first launch
        if persistenceService.loadSchedule() == nil {
            isShowingOnboarding = true
            return
        }
        
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
