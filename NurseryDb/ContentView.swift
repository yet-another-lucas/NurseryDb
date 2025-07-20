import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("Nursery Database")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                
                // Button 1: Add Plants
                NavigationLink(destination: AddPlantsView()) {
                    MainButton(title: "Add Plant(s)", iconName: "plus.circle.fill")
                }
                
                // Button 2: Scan Plants
                NavigationLink(destination: ScanPlantsView()) {
                    MainButton(title: "Scan Plants", iconName: "camera.fill")
                }
                
                // Button 3: Manage Data
                NavigationLink(destination: ManageDataView()) {
                    MainButton(title: "Manage Data", iconName: "folder.fill")
                }
                
                // Button 4: Settings
                NavigationLink(destination: SettingsView()) {
                    MainButton(title: "Settings", iconName: "gearshape.fill")
                }
                    
                // Button 5: labs qr code button
                NavigationLink(destination: WipQrCodeView()) {
                    MainButton(title: "Generate Code", iconName: "cloud.hail.fill")
                }
                // Button 6: labs qr scan button
                NavigationLink(destination: WipScannerView()) {
                    MainButton(title: "Scan Code", iconName: "cloud.hail.fill")
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

// Reusable button component
struct MainButton: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title)
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green.opacity(0.2))
        .cornerRadius(15)
        .foregroundColor(.green)
    }
}

#Preview("Interactive Preview") {
    ContentView()
        .previewNavigationStack() // Enables navigation in previews
}

// Add this extension to enable navigation in previews
extension View {
    func previewNavigationStack() -> some View {
        NavigationStack {
            self
        }
        .modelContainer(previewContainer) // Include if using SwiftData
    }
}

// Add this if you're using SwiftData (simplified version)
@MainActor
let previewContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Plant.self, configurations: config)
        return container
    } catch {
        fatalError("Failed to create preview container")
    }
}()
