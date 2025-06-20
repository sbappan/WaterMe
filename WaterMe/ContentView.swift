//
//  ContentView.swift
//  WaterMe
//
//  Created by Santhosh Appan on 2025-06-20.
//

import SwiftUI

struct ContentView: View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
