//
//  ContentView.swift
//  WaterMe
//
//  Created by Santhosh Appan on 2025-06-20.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingOnboarding = false
    private let persistenceService = PersistenceService()

    var body: some View {
        NavigationView {
            VStack {
                Text("Main Progress Screen")
                
                NavigationLink(destination: SettingsView()) {
                    Text("Go to Settings")
                }
                .padding()
            }
            .navigationTitle("Water Me")
        }
        .onAppear {
            if persistenceService.loadSchedule() == nil {
                isShowingOnboarding = true
            }
        }
        .sheet(isPresented: $isShowingOnboarding) {
            OnboardingView(isPresented: $isShowingOnboarding)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
