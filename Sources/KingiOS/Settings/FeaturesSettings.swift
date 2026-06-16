import SwiftUI

struct FeaturesSettings: View {
    @EnvironmentObject var featureManager: FeatureManager
    @State private var showDeleteConfirmation = false
    @State private var featureToDelete: String?

    var body: some View {
        NavigationView {
            List {
                ForEach(featureManager.features, id: \.name) { feature in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(feature.name)
                                    .font(.headline)
                                Text(feature.isEnabled ? "Enabled" : "Disabled")
                                    .font(.caption)
                                    .foregroundColor(feature.isEnabled ? .green : .secondary)
                            }

                            Spacer()

                            Toggle("", isOn: Binding(
                                get: { feature.isEnabled },
                                set: { newValue in
                                    featureManager.toggleFeature(feature.name, enabled: newValue)
                                }
                            ))
                        }

                        if !feature.isEnabled {
                            Text("This feature will be hidden on next boot")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.vertical, 4)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            featureToDelete = feature.name
                            showDeleteConfirmation = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }

                // Add feature button
                Button(action: {
                    featureManager.addFeature("Dynamic Island")
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                        Text("Add Feature")
                    }
                }
            }
            .navigationTitle("Features")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Delete Feature", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let name = featureToDelete {
                        featureManager.removeFeature(name)
                    }
                }
            } message: {
                Text("This will permanently remove the feature. A restart is required.")
            }
        }
    }
}