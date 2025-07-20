import SwiftUI
import PhotosUI
import SwiftData

struct AddPlantsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var quantityToAdd = 1 // Now a view state instead of model property
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccessHUD = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    @State private var plant = Plant()
    @State private var showScientificNamePicker = false
    @State private var showCultivarPicker = false
    @State private var showContainerSizePicker = false
    @State private var showQuantityPicker = false
    @State private var showImageSourceDialog = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    // Sample data
    let scientificNames = ["Rosa", "Lavandula", "Salvia", "Echinacea", "Hosta"]
    let cultivars = ["'Peace'", "'English'", "'May Night'", "'Purpurea'", "'Patriot'"]
    let containerSizes = ["1 gal", "2 gal", "3 gal", "5 gal", "7 gal", "15 gal"]
    let quantities = Array(1...20)
    
    var body: some View {
        Form {
            // Plant Information Section
            Section(header: Text("Plant Information")) {
                scientificNameField
                cultivarField
            }
            
            // Container Information Section
            Section {
                containerSizeField
                quantityField
            }
            
            // Photo Section
            photoSection
            
            // Notes Section
            Section(header: Text("Notes")) {
                TextEditor(text: $plant.notes)
                    .frame(minHeight: 100)
            }
        }
        .navigationTitle("Add New Plant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    savePlants()
                }
                .disabled(plant.scientificName.isEmpty)
            }
        }
        .confirmationDialog("Select Photo Source", isPresented: $showImageSourceDialog) {
            Button("Camera") {
                sourceType = .camera
                showImagePicker = true
            }
            Button("Photo Library") {
                sourceType = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType) { image in
                plant.photoData = image.jpegData(compressionQuality: 0.8)
            }
            .ignoresSafeArea()
        }
        .overlay {
            if showSuccessHUD {
                SuccessHUD(plantCount: quantityToAdd)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showSuccessHUD = false
                                clearForm()
                            }
                        }
                    }
            }
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func savePlants() {
            guard !plant.scientificName.isEmpty else {
                showError(message: "Scientific name is required")
                return
            }
            
            do {
                // Create multiple individual plant records
                for _ in 1...quantityToAdd {
                    let newPlant = Plant(
                        scientificName: plant.scientificName,
                        cultivarName: plant.cultivarName,
                        containerSize: plant.containerSize,
                        notes: plant.notes,
                        photoData: plant.photoData
                    )
                    modelContext.insert(newPlant)
                }
                
                try modelContext.save()
                withAnimation {
                    showSuccessHUD = true
                }
            } catch {
                showError(message: "Failed to save plants: \(error.localizedDescription)")
            }
        }

    private func showError(message: String) {
        errorMessage = message
        showErrorAlert = true
    }
    
    private func clearForm() {
        plant = Plant() // Reset form
        // Keep quantity at 1 for new entries
//        plant.quantity = 1
        // Reset all picker states
        showScientificNamePicker = false
        showCultivarPicker = false
        showContainerSizePicker = false
        showQuantityPicker = false
    }
    
    // ... (keep all your existing subviews like scientificNameField, etc.) ...
}

struct SuccessHUD: View {
    let plantCount: Int
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.green)
            Text(plantCount == 1 ? "Plant Saved!" : "\(plantCount) Plants Saved!")
                .font(.headline)
                .padding(.top, 8)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
    
    
}

// All subviews now properly included in the main view
extension AddPlantsView {
    private var scientificNameField: some View {
        DisclosureGroup(
            isExpanded: $showScientificNamePicker,
            content: {
                Picker("Select Scientific Name", selection: $plant.scientificName) {
                    ForEach(scientificNames, id: \.self) { name in
                        Text(name).tag(name)
                    }
                }
                .pickerStyle(.wheel)
            },
            label: {
                HStack {
                    Text("Scientific Name")
                    Spacer()
                    Text(plant.scientificName.isEmpty ? "Select" : plant.scientificName)
                        .foregroundColor(plant.scientificName.isEmpty ? .gray : .primary)
                }
            }
        )
    }
    
    private var cultivarField: some View {
        DisclosureGroup(
            isExpanded: $showCultivarPicker,
            content: {
                Picker("Select Cultivar", selection: $plant.cultivarName) {
                    ForEach(cultivars, id: \.self) { cultivar in
                        Text(cultivar).tag(cultivar)
                    }
                }
                .pickerStyle(.wheel)
            },
            label: {
                HStack {
                    Text("Cultivar Name")
                    Spacer()
                    Text(plant.cultivarName.isEmpty ? "Select" : plant.cultivarName)
                        .foregroundColor(plant.cultivarName.isEmpty ? .gray : .primary)
                }
            }
        )
    }
    
    private var containerSizeField: some View {
        DisclosureGroup(
            isExpanded: $showContainerSizePicker,
            content: {
                Picker("Select Container Size", selection: $plant.containerSize) {
                    ForEach(containerSizes, id: \.self) { size in
                        Text(size).tag(size)
                    }
                }
                .pickerStyle(.wheel)
            },
            label: {
                HStack {
                    Text("Container Size")
                    Spacer()
                    Text(plant.containerSize.isEmpty ? "Select" : plant.containerSize)
                        .foregroundColor(plant.containerSize.isEmpty ? .gray : .primary)
                }
            }
        )
    }
    
//    private var quantityField: some View {
//        DisclosureGroup(
//            isExpanded: $showQuantityPicker,
//            content: {
//                Picker("Select Quantity", selection: $plant.quantity) {
//                    ForEach(quantities, id: \.self) { qty in
//                        Text("\(qty)").tag(qty)
//                    }
//                }
//                .pickerStyle(.wheel)
//            },
//            label: {
//                HStack {
//                    Text("Quantity")
//                    Spacer()
//                    Text("\(plant.quantity)")
//                }
//            }
//        )
//    }
 
    private var quantityField: some View {
            DisclosureGroup(
                isExpanded: $showQuantityPicker,
                content: {
                    Picker("Select Quantity", selection: $quantityToAdd) {
                        ForEach(1...20, id: \.self) { qty in
                            Text("\(qty)").tag(qty)
                        }
                    }
                    .pickerStyle(.wheel)
                },
                label: {
                    HStack {
                        Text("Quantity to Add")
                        Spacer()
                        Text("\(quantityToAdd)")
                    }
                }
            )
        }
    
    private var photoSection: some View {
        Section(header: Text("Photo")) {
            if let photo = plant.photo {
                photo
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
            }
            
            Button(action: { showImageSourceDialog = true }) {
                Label(plant.photoData == nil ? "Add Photo" : "Change Photo", systemImage: "camera")
            }
        }
    }
}

//#Preview {
//    // Set up a SwiftData in-memory container for preview
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Plant.self, configurations: config)
//
//    // Return the view with the container
//    return NavigationStack {
//        AddPlantsView()
//            .modelContainer(container)
//    }
//}
