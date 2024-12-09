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
            .padding(.horizontal)
            
            if reviews.isEmpty {
                Text("No reviews yet")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(reviews.sorted { $0.date > $1.date }) { review in
                            ReviewCard(review: review)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}
