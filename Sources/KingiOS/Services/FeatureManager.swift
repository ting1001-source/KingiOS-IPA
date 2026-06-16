import Foundation

class FeatureManager: ObservableObject {
    @Published var features: [Feature] = []

    private let featuresFileName = "installed_features.json"
    private let featuresDirectory = "features"
    private let fileManager = FileManager.default

    init() {
        loadFeatures()
    }

    var featuresPath: URL {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsPath.appendingPathComponent(featuresDirectory)
    }

    func loadFeatures() {
        // Check if features directory exists in root
        let rootFeaturesPath = URL(fileURLWithPath: "/").appendingPathComponent(featuresDirectory)
        let actualPath = fileManager.fileExists(atPath: rootFeaturesPath.path) ? rootFeaturesPath : featuresPath

        if !fileManager.fileExists(atPath: actualPath.path) {
            try? fileManager.createDirectory(at: actualPath, withIntermediateDirectories: true)
        }

        // Load installed features
        do {
            let contents = try fileManager.contentsOfDirectory(at: actualPath, includingPropertiesForKeys: nil)
            features = contents.compactMap { url in
                let name = url.lastPathComponent
                let disabledFile = url.appendingPathComponent("disabled")
                let isEnabled = !fileManager.fileExists(atPath: disabledFile.path)
                return Feature(name: name, isEnabled: isEnabled)
            }
        } catch {
            // Add default features if none exist
            if features.isEmpty {
                features = [Feature(name: "Dynamic Island", isEnabled: true)]
                saveFeatures()
            }
        }
    }

    func isFeatureEnabled(_ name: String) -> Bool {
        features.first(where: { $0.name == name })?.isEnabled ?? false
    }

    func toggleFeature(_ name: String, enabled: Bool) {
        if let index = features.firstIndex(where: { $0.name == name }) {
            features[index].isEnabled = enabled

            let featurePath = featuresPath.appendingPathComponent(name)
            let disabledFile = featurePath.appendingPathComponent("disabled")

            if !enabled {
                try? fileManager.createDirectory(at: featurePath, withIntermediateDirectories: true)
                fileManager.createFile(atPath: disabledFile.path, contents: nil)
            } else {
                try? fileManager.removeItem(at: disabledFile)
            }
        }
    }

    func addFeature(_ name: String) {
        let featurePath = featuresPath.appendingPathComponent(name)
        try? fileManager.createDirectory(at: featurePath, withIntermediateDirectories: true)
        if !features.contains(where: { $0.name == name }) {
            features.append(Feature(name: name, isEnabled: true))
        }
    }

    func removeFeature(_ name: String) {
        let featurePath = featuresPath.appendingPathComponent(name)
        try? fileManager.removeItem(at: featurePath)
        features.removeAll { $0.name == name }
    }

    private func saveFeatures() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(features) {
            let filePath = featuresPath.appendingPathComponent(featuresFileName)
            try? data.write(to: filePath)
        }
    }
}

struct Feature: Codable, Identifiable {
    let id = UUID()
    let name: String
    var isEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case name, isEnabled
    }
}