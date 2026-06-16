import SwiftUI

struct LiquidGlassSettings: View {
    @AppStorage("liquidGlassOpacity") private var opacity: Double = 0.3
    @State private var previewOpacity: Double = 0.3

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Liquid Glass")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                Text("Adjust the transparency and frosting effect of the glass overlay.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Preview
                ZStack {
                    // Background gradient
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple, .pink]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    // Liquid glass overlay
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(previewOpacity)
                }
                .frame(height: 200)
                .cornerRadius(20)
                .padding(.horizontal)
                .overlay(
                    Text("Preview")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                )

                // Slider
                VStack(spacing: 8) {
                    HStack {
                        Text("Clear")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Frosted")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    Slider(value: $previewOpacity, in: 0.0...1.0)
                        .tint(Color(red: 233/255, green: 69/255, blue: 96/255))
                        .padding(.horizontal)
                        .onChange(of: previewOpacity) { newValue in
                            opacity = newValue
                        }

                    Text("Opacity: \(Int(previewOpacity * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                Spacer()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        opacity = previewOpacity
                    }
                }
            }
            .onAppear {
                previewOpacity = opacity
            }
        }
    }
}