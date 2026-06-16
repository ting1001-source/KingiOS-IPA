import SwiftUI

@main
struct KingiOSApp: App {
    @StateObject private var bootManager = BootManager()
    @StateObject private var featureManager = FeatureManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bootManager)
                .environmentObject(featureManager)
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var bootManager: BootManager
    @StateObject private var homeViewModel = HomeViewModel()

    var body: some View {
        ZStack {
            if bootManager.isBooting {
                BootView()
                    .transition(.opacity)
            } else {
                HomeView()
                    .environmentObject(homeViewModel)
            }
        }
        .onAppear {
            bootManager.startBootSequence()
        }
    }
}

class BootManager: ObservableObject {
    @Published var isBooting = true
    @Published var bootProgress: CGFloat = 0
    @Published var bootMessage = "Initializing..."

    func startBootSequence() {
        bootProgress = 0
        isBooting = true
        bootMessage = "Loading King iOS..."

        let steps: [(CGFloat, String, Double)] = [
            (0.15, "Initializing kernel...", 0.5),
            (0.30, "Loading system services...", 0.8),
            (0.45, "Configuring features...", 0.6),
            (0.60, "Checking Dynamic Island...", 0.7),
            (0.75, "Setting up King PC...", 0.5),
            (0.90, "Finalizing...", 0.4),
            (1.0, "King iOS Ready", 0.3)
        ]

        var delay = 0.0
        for step in steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: step.2)) {
                    self.bootProgress = step.0
                    self.bootMessage = step.1
                }
            }
            delay += step.2
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.5) {
            withAnimation(.easeOut(duration: 0.8)) {
                self.isBooting = false
            }
        }
    }
}