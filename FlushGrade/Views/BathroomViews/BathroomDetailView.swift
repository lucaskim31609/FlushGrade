import SwiftUI

struct BathroomDetailView: View {
    let bathroom: Bathroom
    @ObservedObject var viewModel: BathroomViewModel
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showingAddReview = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                BathroomInfoSection(bathroom: bathroom)
                ReviewsSection(reviews: bathroom.reviews)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddReview = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $showingAddReview) {
            AddReviewView(
                bathroom: bathroom,
                viewModel: viewModel,
                authViewModel: authViewModel
            )
        }
    }
}
