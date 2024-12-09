import Foundation
import CoreLocation

struct Bathroom: Identifiable {
    var id: String?
    let building: String
    let floor: Int
    let gender: String
    let isAccessible: Bool
    let location: String
    var reviews: [Review]
    let latitude: Double
    let longitude: Double
    let address: String
        
        var coordinates: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    
    var averageRating: Double {
        guard !reviews.isEmpty else { return 0 }
        return reviews.map { $0.rating }.reduce(0, +) / Double(reviews.count)
    }
}
