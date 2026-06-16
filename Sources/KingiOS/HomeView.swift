import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var showAppSwitcher = false
    @Published var showHomeMenu = false
    @Published var selectedApp: String? = nil
    @Published var openApps: [String] = ["Settings", "Files", "Camera", "Clock"]
    @Published var showDynamicIsland = true

    let apps: [[String: String]] = [
        ["name": "Settings", "icon": "gearshape.fill"],
        ["name": "Files", "icon": "folder.fill"],
        ["name": "Camera", "icon": "camera.fill"],
        ["name": "Clock", "icon": "clock.fill"],
        ["name": "Photos", "icon": "photo.fill"],
        ["name": "Phone", "icon": "phone.fill"],
        ["name": "Messages", "icon": "message.fill"],
        ["name": "King PC", "icon": "display"],
        ["name": "Browser", "icon": "globe"],
        ["name": "Music", "icon": "music.note"],
        ["name": "Maps", "icon": "map.fill"],
        ["name": "Weather", "icon": "cloud.sun.fill"]
    ]
}

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var featureManager: FeatureManager
    @State private var showLiquidGlass = false
    @State private var swipeOffset: CGFloat = 0

    var body: some View {
        ZStack {
            wallpaperView
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Status Bar
                statusBarView
                    .padding(.horizontal)
                    .padding(.top, 6)
                    .padding(.bottom, 4)

                // Dynamic Island (if enabled)
                if viewModel.showDynamicIsland && featureManager.isFeatureEnabled("Dynamic Island") {
                    DynamicIslandOverlay()
                        .padding(.bottom, 8)
                }

                // App Grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 20) {
                        ForEach(viewModel.apps, id: \.self) { app in
                            AppIconView(app: app)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }

                // Dock area
                dockView
                    .padding(.bottom, 8)
            }

            // Dynamic Swipe bar at bottom
            VStack {
                Spacer()
                dynamicSwipeBar
                    .padding(.bottom, 6)
            }

            // App Switcher overlay
            if viewModel.showAppSwitcher {
                AppSwitcherView()
                    .transition(.move(edge: .bottom))
                    .zIndex(10)
            }

            // Home Menu overlay
            if viewModel.showHomeMenu {
                HomeMenuView()
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(20)
            }
        }
        .onAppear {
            showLiquidGlass = true
        }
    }

    private var wallpaperView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.18),
                    Color(red: 0.08, green: 0.08, blue: 0.15),
                    Color(red: 0.05, green: 0.05, blue: 0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            if showLiquidGlass {
                LiquidGlassView()
                    .allowsHitTesting(false)
            }
        }
    }

    private var statusBarView: some View {
        HStack {
            Text("9:41")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "wifi")
                Image(systemName: "battery.100")
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.white)
        }
    }

    private var dockView: some View {
        HStack(spacing: 16) {
            AppIconView(app: ["name": "Phone", "icon": "phone.fill"], size: 54)
            AppIconView(app: ["name": "Messages", "icon": "message.fill"], size: 54)
            AppIconView(app: ["name": "Browser", "icon": "globe"], size: 54)
            AppIconView(app: ["name": "Music", "icon": "music.note"], size: 54)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.08))
                .padding(.horizontal, 40)
        )
    }

    private var dynamicSwipeBar: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color.white.opacity(0.5))
            .frame(width: 134, height: 5)
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        swipeOffset = value.translation.height
                        if value.translation.height < -50 {
                            withAnimation {
                                viewModel.showAppSwitcher = true
                            }
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > -30 {
                            // Quick swipe up = go home
                            viewModel.selectedApp = nil
                        }
                        swipeOffset = 0
                    }
            )
            .onLongPressGesture(minimumDuration: 0.3) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    viewModel.showHomeMenu.toggle()
                }
            }
    }
}

struct AppIconView: View {
    let app: [String: String]
    var size: CGFloat = 60
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.22)
                    .fill(iconColor)
                    .frame(width: size, height: size)

                Image(systemName: app["icon"] ?? "app.fill")
                    .font(.system(size: size * 0.45))
                    .foregroundColor(.white)
            }

            Text(app["name"] ?? "")
                .font(.system(size: 11))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .frame(width: size + 16)
        .onTapGesture {
            if app["name"] == "King PC" {
                viewModel.selectedApp = "King PC"
            } else if app["name"] == "Settings" {
                viewModel.selectedApp = "Settings"
            }
        }
    }

    private var iconColor: Color {
        let colors: [Color] = [
            .blue, .green, .orange, .red, .purple,
            .yellow, .pink, .teal, .indigo, .mint, .cyan, .brown
        ]
        let index = abs(app["name"]?.hashValue ?? 0) % colors.count
        return colors[index]
    }
}

struct AppSwitcherView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { viewModel.showAppSwitcher = false }
                }

            VStack {
                Text("App Switcher")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 60)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.openApps, id: \.self) { app in
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 200, height: 280)
                                .overlay(
                                    VStack {
                                        Image(systemName: "app.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                        Text(app)
                                            .foregroundColor(.white)
                                            .fontWeight(.medium)
                                    }
                                )
                                .overlay(
                                    Button(action: {
                                        viewModel.openApps.removeAll { $0 == app }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.red)
                                    }
                                    .padding(8),
                                    alignment: .topTrailing
                                )
                        }
                    }
                    .padding()
                }

                Spacer()

                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 134, height: 5)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct HomeMenuView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { viewModel.showHomeMenu = false }
                }

            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 16) {
                    menuButton(icon: "house.fill", label: "Home", color: .white) {
                        withAnimation {
                            viewModel.showHomeMenu = false
                            viewModel.selectedApp = nil
                        }
                    }

                    menuButton(icon: "arrow.left", label: "Back", color: .orange) {
                        // Android back action
                        withAnimation { viewModel.showHomeMenu = false }
                    }

                    menuButton(icon: "square.split.2x2.fill", label: "App Switcher", color: .blue) {
                        withAnimation {
                            viewModel.showHomeMenu = false
                            viewModel.showAppSwitcher = true
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(red: 0.08, green: 0.08, blue: 0.15))
                        .shadow(color: .black.opacity(0.3), radius: 20)
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 100)
            }
        }
    }

    private func menuButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 32)

                Text(label)
                    .font(.title3)
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
    }
}

struct LiquidGlassView: View {
    @AppStorage("liquidGlassOpacity") private var opacity: Double = 0.3

    var body: some View {
        ZStack {
            // Frosted glass effect
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(opacity)
        }
    }
}