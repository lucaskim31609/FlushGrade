import Foundation

struct Bathroom: Identifiable {
    var id: String?
    let building: String
    let floor: Int
    let gender: String
    let isAccessible: Bool
    let location: String
    var reviews: [Review]
    
    var averageRating: Double {
        guard !reviews.isEmpty else { return 0 }
        return reviews.map { $0.rating }.reduce(0, +) / Double(reviews.count)
    }
}
