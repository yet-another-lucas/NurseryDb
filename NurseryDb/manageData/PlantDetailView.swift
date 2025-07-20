import SwiftUI

struct PlantDetailView: View {
    let plant: Plant
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Photo Section
                if let photo = plant.photo {
                    photo
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .padding(.horizontal)
                } else {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                // Plant Information
                VStack(alignment: .leading, spacing: 16) {
                    InfoCardView(
                        title: "Scientific Name",
                        value: plant.scientificName,
                        systemImage: "tag.fill"
                    )
                    
                    if !plant.cultivarName.isEmpty {
                        InfoCardView(
                            title: "Cultivar",
                            value: plant.cultivarName,
                            systemImage: "leaf.fill"
                        )
                    }
                    
                    HStack(spacing: 16) {
                        InfoCardView(
                            title: "Container Size",
                            value: plant.containerSize,
                            systemImage: "shippingbox.fill",
                            fillWidth: false
                        )
                    }
                    
                    if !plant.notes.isEmpty {
                        InfoCardView(
                            title: "Notes",
                            value: plant.notes,
                            systemImage: "note.text",
                            isMultiline: true
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle(plant.scientificName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: generateShareText()) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    private func generateShareText() -> String {
        var text = "Plant Details:\n"
        text += "Scientific Name: \(plant.scientificName)\n"
        if !plant.cultivarName.isEmpty {
            text += "Cultivar: \(plant.cultivarName)\n"
        }
        if !plant.containerSize.isEmpty {
            text += "Container Size: \(plant.containerSize)\n"
        }
        if !plant.notes.isEmpty {
            text += "Notes: \(plant.notes)"
        }
        return text
    }
}

// Helper view for consistent info cards
struct InfoCardView: View {
    let title: String
    let value: String
    let systemImage: String
    var fillWidth: Bool = true
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title, systemImage: systemImage)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if isMultiline {
                Text(value)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            } else {
                Text(value.isEmpty ? "Not specified" : value)
                    .font(.body)
                    .frame(maxWidth: fillWidth ? .infinity : nil, alignment: .leading)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}
