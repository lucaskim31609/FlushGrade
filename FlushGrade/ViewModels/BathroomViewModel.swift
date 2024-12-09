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
            let fetchedBathrooms = snapshot.documents.compactMap { document -> Bathroom? in
                let data = document.data()
                return Bathroom(
                    id: document.documentID,
                    building: data["building"] as? String ?? "",
                    floor: data["floor"] as? Int ?? 1,
                    gender: data["gender"] as? String ?? "",
                    isAccessible: data["isAccessible"] as? Bool ?? false,
                    location: data["location"] as? String ?? "",
                    reviews: []
                )
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
                "location": bathroom.location
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
                "userID": review.userID
            ]
            
            try await db.collection("bathrooms").document(bathroomId)
                .collection("reviews").addDocument(data: reviewData)
            
            if let index = bathrooms.firstIndex(where: { $0.id == bathroomId }) {
                bathrooms[index].reviews.append(review)
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
}
