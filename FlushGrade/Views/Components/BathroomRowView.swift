import SwiftUI

struct BathroomRowView: View {
    let bathroom: Bathroom
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(bathroom.building)
                        .font(.headline)
                    Text("Floor \(bathroom.floor)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                RatingView(rating: bathroom.averageRating)
            }
            
            HStack {
                Label(bathroom.gender, systemImage: "person.fill")
                if bathroom.isAccessible {
                    Label("Accessible", systemImage: "figure.roll")
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
