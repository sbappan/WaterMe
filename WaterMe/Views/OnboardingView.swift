import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to WaterMe!")
                    .font(.largeTitle)
                    .padding()
                
                Text("This app will help you track your daily water intake.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Get Started")
                }
                .padding()
            }
            .navigationTitle("Welcome")
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isPresented: .constant(true))
    }
} 