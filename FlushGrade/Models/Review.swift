import Foundation

struct Review: Identifiable {
    var id: String?
    let rating: Double
    let cleanliness: Int
    let comment: String
    let date: Date
    let userId: String
    let userEmail: String
    
    init(id: String? = UUID().uuidString,
         rating: Double,
         cleanliness: Int,
         comment: String,
         date: Date = Date(),
         userId: String,
         userEmail: String) {
        self.id = id
        self.rating = rating
        self.cleanliness = cleanliness
        self.comment = comment
        self.date = date
        self.userId = userId
        self.userEmail = userEmail
    }
}
