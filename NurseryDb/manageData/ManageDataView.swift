import SwiftUI
import SwiftData

struct ManageDataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Plant.dateAdded, order: .reverse) private var plants: [Plant]
    
    @State private var searchText = ""
    @State private var showDeleteConfirmation = false
    @State private var plantToDelete: Plant?
    
    var body: some View {
        NavigationStack {
            Group {
                if plants.isEmpty {
                    ContentUnavailableView(
                        "No Plants Saved",
                        systemImage: "leaf",
                        description: Text("Add your first plant using the 'Add Plant' screen")
                    )
                } else {
                    List {
                        ForEach(filteredPlants) { plant in
                            NavigationLink {
                                PlantDetailView(plant: plant)
                            } label: {
                                PlantRowView(plant: plant)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    plantToDelete = plant
                                    showDeleteConfirmation = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Plants")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .confirmationDialog("Delete Plant", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let plant = plantToDelete {
                        deletePlant(plant)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this plant?")
            }
        }
    }
    
    private var filteredPlants: [Plant] {
        if searchText.isEmpty {
            return plants
        } else {
            return plants.filter {
                $0.scientificName.localizedCaseInsensitiveContains(searchText) ||
                $0.cultivarName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func deletePlant(_ plant: Plant) {
        modelContext.delete(plant)
    }
}



struct PlantRowView: View {
    let plant: Plant
    
    var body: some View {
        HStack(spacing: 12) {
            if let photo = plant.photo {
                photo
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.green)
                    .frame(width: 50, height: 50)
                    .background(Color.green.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(plant.scientificName)
                    .font(.headline)
                
                if !plant.cultivarName.isEmpty {
                    Text(plant.cultivarName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    if !plant.containerSize.isEmpty {
                        Text(plant.containerSize)
                            .font(.caption)
                            .padding(4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
