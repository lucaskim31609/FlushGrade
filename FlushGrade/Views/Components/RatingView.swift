import SwiftUI

struct RatingView: View {
    let rating: Double
    let color: Color = .yellow
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= Int(rating) ? "star.fill" : "star")
                    .foregroundColor(color)
            }
            Text(String(format: "%.1f", rating))
                .foregroundColor(.secondary)
        }
    }
}
