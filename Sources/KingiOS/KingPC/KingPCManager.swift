import SwiftUI
import Network
import UIKit

struct KingPCView: View {
    @EnvironmentObject var featureManager: FeatureManager
    @State private var scannedDevices: [PCDevice] = []
    @State private var connectedDevices: [PCDevice] = []
    @State private var isScanning = false
    @State private var isConnected = false
    @State private var showFullScreen = false
    @State private var selectedDevice: PCDevice?

    var body: some View {
        List {
            // Scan Section
            Section("Available Devices") {
                Button(action: scanForDevices) {
                    HStack {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .foregroundColor(.blue)
                        Text(isScanning ? "Scanning..." : "Scan for Devices")
                    }
                }
                .disabled(isScanning)

                ForEach(scannedDevices) { device in
                    Button(action: { selectedDevice = device }) {
                        HStack {
                            Image(systemName: "display")
                                .foregroundColor(.secondary)
                            VStack(alignment: .leading) {
                                Text(device.name)
                                    .foregroundColor(.primary)
                                Text(device.ipAddress)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if selectedDevice?.id == device.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }

                if !scannedDevices.isEmpty {
                    Button("Connect Selected") {
                        connectToDevice(selectedDevice)
                    }
                    .disabled(selectedDevice == nil)
                }
            }

            // Connected Devices
            if !connectedDevices.isEmpty {
                Section("Connected Devices") {
                    ForEach(connectedDevices) { device in
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text(device.name)
                            Spacer()
                            Button("Disconnect") {
                                disconnectDevice(device)
                            }
                            .foregroundColor(.red)
                            .font(.caption)
                        }
                    }

                    Button(role: .destructive) {
                        disconnectAll()
                    } label: {
                        Label("Disconnect All", systemImage: "eject.fill")
                    }
                }
            }

            // Actions
            Section("Actions") {
                Button(action: usePhoneAsScreen) {
                    HStack {
                        Image(systemName: "iphone.gen3")
                            .foregroundColor(.blue)
                        Text("Use Phone as Screen")
                    }
                }

                Button(action: reorderDisplays) {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.orange)
                        Text("Reorder Displays")
                    }
                }
            }
        }
        .navigationTitle("King PC")
        .fullScreenCover(isPresented: $showFullScreen) {
            KingPCFullScreenView(devices: connectedDevices)
        }
    }

    private func scanForDevices() {
        isScanning = true
        scannedDevices = []

        // Simulated scan - in real app, uses Bonjour/mDNS
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            scannedDevices = [
                PCDevice(name: UIDevice.current.name, ipAddress: "Local Device"),
                PCDevice(name: "Living Room PC", ipAddress: "192.168.1.100"),
                PCDevice(name: "Office PC", ipAddress: "192.168.1.101")
            ]
            isScanning = false
        }
    }

    private func connectToDevice(_ device: PCDevice?) {
        guard let device = device else { return }
        connectedDevices.append(device)
        isConnected = true
    }

    private func disconnectDevice(_ device: PCDevice) {
        connectedDevices.removeAll { $0.id == device.id }
        if connectedDevices.isEmpty { isConnected = false }
    }

    private func disconnectAll() {
        connectedDevices.removeAll()
        isConnected = false
    }

    private func usePhoneAsScreen() {
        showFullScreen = true
    }

    private func reorderDisplays() {
        // Opens reorder interface
    }
}

struct PCDevice: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let ipAddress: String
}

struct KingPCFullScreenView: View {
    let devices: [PCDevice]
    @Environment(\.dismiss) var dismiss
    @State private var showKeyboard = false
    @State private var keyboardText = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                // Top bar
                HStack {
                    Button("Stop Using") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)

                    Spacer()

                    Text("King PC")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)

                    Spacer()

                    Button(action: { showKeyboard.toggle() }) {
                        Image(systemName: "keyboard")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 50)
                .padding(.bottom, 10)

                // Remote screen area
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.05, green: 0.05, blue: 0.1))
                        .overlay(
                            VStack {
                                Image(systemName: "display")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.3))
                                Text("PC Screen")
                                    .foregroundColor(.white.opacity(0.5))
                                Text("Connected: \(devices.map(\.name).joined(separator: ", "))")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.3))
                            }
                        )
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.6)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2.5)
                        .gesture(
                            DragGesture()
                                .onChanged { _ in }
                        )
                }

                Spacer()

                // Keyboard overlay
                if showKeyboard {
                    VStack {
                        TextField("Type here...", text: $keyboardText)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        Button("Close Keyboard") {
                            showKeyboard = false
                        }
                        .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                }
            }
        }
        .statusBar(hidden: true)
    }
}