import SwiftUI
import FirebaseAuth

struct AddReviewView: View {
    let bathroom: Bathroom
    @ObservedObject var viewModel: BathroomViewModel
    @ObservedObject var authViewModel: AuthViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var rating: Double = 3
    @State private var cleanliness: Int = 3
    @State private var comment: String = ""
    
    private var userId: String {
        Auth.auth().currentUser?.uid ?? "anonymous"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rating")) {
                    Slider(value: $rating, in: 1...5, step: 0.5) {
                        Text("Rating")
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("5")
                    }
                    RatingView(rating: rating)
                }
                
                Section(header: Text("Cleanliness")) {
                    Picker("Cleanliness", selection: $cleanliness) {
                        ForEach(1...5, id: \.self) { rating in
                            Text("\(rating)").tag(rating)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Comment")) {
                    TextEditor(text: $comment)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Review")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Submit") {
                    submitReview()
                }
                .disabled(comment.isEmpty)
            )
        }
    }
    
    private func submitReview() {
        Task {
            let currentUser = Auth.auth().currentUser
            let review = Review(
                id: nil,
                rating: rating,
                cleanliness: cleanliness,
                comment: comment,
                date: Date(),
                userId: currentUser?.uid ?? "anonymous",
                userEmail: currentUser?.email ?? "Anonymous User"
            )
                
            await viewModel.addReview(to: bathroom, review: review)
            dismiss()
        }
    }
}
