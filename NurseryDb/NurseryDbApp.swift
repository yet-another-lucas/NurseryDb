import SwiftUI
import SwiftData

@main
struct PlantManagerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Plant.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer) // This is crucial
    }
}
