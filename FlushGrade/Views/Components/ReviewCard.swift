import SwiftUI

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                RatingView(rating: review.rating)
                Spacer()
                Text(review.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "sparkles")
                Text("Cleanliness:")
                RatingView(rating: Double(review.cleanliness))
                    .font(.caption)
            }
            
            Text(review.comment)
                .font(.body)
            
            Divider()
        }
        .padding(.vertical, 8)
    }
}
