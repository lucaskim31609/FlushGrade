import SwiftUI

struct ReviewsSection: View {
    let reviews: [Review]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Reviews")
                    .font(.title2)
                    .bold()
                Spacer()
                Text("\(reviews.count) reviews")
                    .foregroundColor(.secondary)
            }
            
            if reviews.isEmpty {
                Text("No reviews yet")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(reviews) { review in
                    ReviewCard(review: review)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
