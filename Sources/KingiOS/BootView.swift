import SwiftUI

struct BootView: View {
    @EnvironmentObject var bootManager: BootManager
    @State private var showKingText = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 60) {
                Spacer()

                VStack(spacing: 8) {
                    Text("King iOS")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(showKingText ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.2), value: showKingText)

                    Text("Powered by Android")
                        .font(.system(size: 16))
                        .foregroundColor(Color.gray.opacity(0.7))
                }

                VStack(spacing: 12) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.white.opacity(0.15))
                                .frame(height: 4)

                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(red: 233/255, green: 69/255, blue: 96/255))
                                .frame(width: geo.size.width * bootManager.bootProgress, height: 4)
                                .animation(.easeInOut(duration: 0.3), value: bootManager.bootProgress)
                        }
                    }
                    .frame(width: 200, height: 4)

                    Text(bootManager.bootMessage)
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.6))
                }

                Spacer()

                Text("King iOS v1.0.0")
                    .font(.system(size: 11))
                    .foregroundColor(Color.gray.opacity(0.4))
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            showKingText = true
        }
    }
}