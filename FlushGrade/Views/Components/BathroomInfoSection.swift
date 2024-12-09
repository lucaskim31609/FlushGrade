import SwiftUI

struct BathroomInfoSection: View {
    let bathroom: Bathroom
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(bathroom.building)
                        .font(.title)
                        .bold()
                    Text("Floor \(bathroom.floor)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                Spacer()
                RatingView(rating: bathroom.averageRating)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                DetailRow(icon: "location", text: bathroom.location)
                DetailRow(icon: "person.fill", text: bathroom.gender)
                if bathroom.isAccessible {
                    DetailRow(icon: "figure.roll", text: "Wheelchair accessible")
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
