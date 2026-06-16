import SwiftUI

struct DynamicIslandOverlay: View {
    @State private var isExpanded = false
    @State private var showContent = false

    var body: some View {
        HStack {
            Spacer()

            ZStack {
                // Dynamic Island pill shape
                RoundedRectangle(cornerRadius: isExpanded ? 20 : 22)
                    .fill(Color.black)
                    .frame(width: isExpanded ? 280 : 120, height: 36)
                    .overlay(
                        ZStack {
                            // Camera dot
                            Circle()
                                .fill(Color(red: 0.1, green: 0.1, blue: 0.12))
                                .frame(width: 10, height: 10)
                                .offset(x: isExpanded ? -120 : 0)

                            if isExpanded {
                                HStack(spacing: 20) {
                                    Image(systemName: "music.note")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Text("Now Playing")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Image(systemName: "waveform")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                                .transition(.opacity)
                            }
                        }
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isExpanded.toggle()
                        }
                    }

            }

            Spacer()
        }
    }
}