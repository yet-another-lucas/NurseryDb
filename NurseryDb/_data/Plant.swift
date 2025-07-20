import SwiftData
import SwiftUI

@Model
class Plant {
    @Attribute(.unique) var id = UUID()
    var scientificName: String
    var cultivarName: String
    var containerSize: String
    var notes: String
    var photoData: Data?
    var dateAdded: Date  // Add this for sorting
    
    init(scientificName: String = "",
         cultivarName: String = "",
         containerSize: String = "",
         quantity: Int = 1,
         notes: String = "",
         photoData: Data? = nil,
         dateAdded: Date = Date()) {
        self.scientificName = scientificName
        self.cultivarName = cultivarName
        self.containerSize = containerSize
        self.notes = notes
        self.photoData = photoData
        self.dateAdded = dateAdded
    }
    
    var photo: Image? {
        guard let photoData, let uiImage = UIImage(data: photoData) else { return nil }
        return Image(uiImage: uiImage)
    }
}
