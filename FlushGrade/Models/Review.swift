import Foundation

struct Review: Identifiable {
    let id: String?
    let rating: Double
    let cleanliness: Int
    let comment: String
    let date: Date
    let userID: String
    
    init(id: String? = UUID().uuidString,
         rating: Double,
         cleanliness: Int,
         comment: String,
         date: Date = Date(),
         userID: String) {
        self.id = id
        self.rating = rating
        self.cleanliness = cleanliness
        self.comment = comment
        self.date = date
        self.userID = userID
    }
}
