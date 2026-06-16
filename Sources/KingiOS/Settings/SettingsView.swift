import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var featureManager: FeatureManager
    @State private var showLiquidGlassSettings = false
    @State private var showFeaturesSettings = false

    var body: some View {
        NavigationView {
            List {
                // King iOS Group
                Section("King iOS") {
                    Button(action: { showLiquidGlassSettings = true }) {
                        HStack {
                            Image(systemName: "drop.circle.fill")
                                .foregroundColor(Color(red: 233/255, green: 69/255, blue: 96/255))
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Liquid Glass")
                                    .foregroundColor(.primary)
                                Text("Adjust transparency and frosting effect")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    Button(action: { showFeaturesSettings = true }) {
                        HStack {
                            Image(systemName: "sparkles.square.fill")
                                .foregroundColor(Color(red: 233/255, green: 69/255, blue: 96/255))
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Features")
                                    .foregroundColor(.primary)
                                Text("Manage installed features")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    NavigationLink(destination: KingPCView()) {
                        HStack {
                            Image(systemName: "display")
                                .foregroundColor(Color(red: 233/255, green: 69/255, blue: 96/255))
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("King PC")
                                    .foregroundColor(.primary)
                                Text("Connect to external displays")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                // Regular Settings
                Section("General") {
                    settingRow(icon: "wifi", color: .blue, title: "Wi-Fi")
                    settingRow(icon: "bluetooth", color: .blue, title: "Bluetooth")
                    settingRow(icon: "antenna.radiowaves.left.and.right", color: .green, title: "Cellular")
                    settingRow(icon: "bell.badge.fill", color: .red, title: "Notifications")
                    settingRow(icon: "display", color: .purple, title: "Display & Brightness")
                    settingRow(icon: "lock.fill", color: .blue, title: "Face ID & Passcode")
                }

                Section("Apps") {
                    settingRow(icon: "square.grid.2x2", color: .indigo, title: "App Store")
                    settingRow(icon: "arrow.down.app", color: .blue, title: "Installed APKs")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.selectedApp = nil
                    }
                }
            }
            .sheet(isPresented: $showLiquidGlassSettings) {
                LiquidGlassSettings()
            }
            .sheet(isPresented: $showFeaturesSettings) {
                FeaturesSettings()
            }
        }
    }

    private func settingRow(icon: String, color: Color, title: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 28)
            Text(title)
                .foregroundColor(.primary)
        }
    }
}