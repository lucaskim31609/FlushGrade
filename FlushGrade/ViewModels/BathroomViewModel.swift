import SwiftUI
import FirebaseFirestore

@MainActor
class BathroomViewModel: ObservableObject {
    @Published var bathrooms: [Bathroom] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    func fetchBathrooms() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let snapshot = try await db.collection("bathrooms").getDocuments()
            var fetchedBathrooms: [Bathroom] = []
            
            for document in snapshot.documents {
                let data = document.data()
                
                let reviewsSnapshot = try await document.reference.collection("reviews").getDocuments()
                let reviews = reviewsSnapshot.documents.compactMap { reviewDoc -> Review? in
                    let reviewData = reviewDoc.data()
                    return Review(
                        id: reviewDoc.documentID,
                        rating: reviewData["rating"] as? Double ?? 0,
                        cleanliness: reviewData["cleanliness"] as? Int ?? 0,
                        comment: reviewData["comment"] as? String ?? "",
                        date: (reviewData["date"] as? Timestamp)?.dateValue() ?? Date(),
                        userId: reviewData["userId"] as? String ?? "",
                        userEmail: reviewData["userEmail"] as? String ?? "Anonymous User"
                    )
                }
                
                let bathroom = Bathroom(
                    id: document.documentID,
                    building: data["building"] as? String ?? "",
                    floor: data["floor"] as? Int ?? 1,
                    gender: data["gender"] as? String ?? "",
                    isAccessible: data["isAccessible"] as? Bool ?? false,
                    location: data["location"] as? String ?? "",
                    reviews: reviews,
                    latitude: data["latitude"] as? Double ?? 42.3355,  // Default to BC's coordinates
                    longitude: data["longitude"] as? Double ?? -71.1685,
                    address: data["address"] as? String ?? ""
                )
                
                fetchedBathrooms.append(bathroom)
            }
            
            self.bathrooms = fetchedBathrooms
        } catch {
            errorMessage = "Error fetching bathrooms: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func addBathroom(_ bathroom: Bathroom) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let data: [String: Any] = [
                "building": bathroom.building,
                "floor": bathroom.floor,
                "gender": bathroom.gender,
                "isAccessible": bathroom.isAccessible,
                "location": bathroom.location,
                "latitude": bathroom.latitude,
                "longitude": bathroom.longitude,
                "address": bathroom.address  // Add this
            ]
            
            let docRef = try await db.collection("bathrooms").addDocument(data: data)
            var newBathroom = bathroom
            newBathroom.id = docRef.documentID
            bathrooms.append(newBathroom)
        } catch {
            errorMessage = "Error adding bathroom: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func addReview(to bathroom: Bathroom, review: Review) async {
        isLoading = true
        errorMessage = nil
        
        do {
            guard let bathroomId = bathroom.id else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid bathroom ID"])
            }
            
            let reviewData: [String: Any] = [
                "rating": review.rating,
                "cleanliness": review.cleanliness,
                "comment": review.comment,
                "date": Timestamp(date: review.date),
                "userId": review.userId,
                "userEmail": review.userEmail
            ]
            
            let reviewRef = try await db.collection("bathrooms")
                .document(bathroomId)
                .collection("reviews")
                .addDocument(data: reviewData)
            
            if let index = bathrooms.firstIndex(where: { $0.id == bathroomId }) {
                var updatedBathroom = bathrooms[index]
                var updatedReview = review
                updatedReview.id = reviewRef.documentID
                updatedBathroom.reviews.append(updatedReview)
                bathrooms[index] = updatedBathroom
            }
        } catch {
            errorMessage = "Error adding review: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func filterBathrooms(by building: String?, searchText: String) -> [Bathroom] {
        var filtered = bathrooms
        
        if let building = building {
            filtered = filtered.filter { $0.building == building }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.building.lowercased().contains(searchText.lowercased()) ||
                $0.location.lowercased().contains(searchText.lowercased())
            }
        }
        
        return filtered
    }
    
    func getUserReviewCount(for userId: String) async -> Int {
        do {
            var totalCount = 0
            let snapshot = try await db.collection("bathrooms").getDocuments()
            
            for document in snapshot.documents {
                let reviewsSnapshot = try await document.reference.collection("reviews")
                    .whereField("userId", isEqualTo: userId)
                    .getDocuments()
                
                totalCount += reviewsSnapshot.documents.count
            }
            
            return totalCount
        } catch {
            print("Error getting review count: \(error.localizedDescription)")
            return 0
        }
    }
}
