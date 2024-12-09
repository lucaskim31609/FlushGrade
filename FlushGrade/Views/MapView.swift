import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: BathroomViewModel
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 42.3355, // BC's coordinates
            longitude: -71.1685
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    ))
    
    var body: some View {
        Map(position: $position) {
            ForEach(viewModel.bathrooms) { bathroom in
                Annotation(
                    bathroom.building,
                    coordinate: bathroom.coordinates
                ) {
                    NavigationLink(destination: BathroomDetailView(bathroom: bathroom, viewModel: viewModel)) {
                        VStack {
                            Image(systemName: "toilet")
                                .foregroundColor(bathroom.isAccessible ? .blue : .gray)
                                .background(
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 35, height: 35)
                                        .shadow(radius: 2)
                                )
                            Text(bathroom.building)
                                .font(.caption)
                                .padding(5)
                                .background(.white)
                                .cornerRadius(5)
                                .shadow(radius: 2)
                        }
                    }
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .mapStyle(.standard(showsTraffic: false))
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .topTrailing) {
            // Legend
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "toilet")
                        .foregroundColor(.blue)
                    Text("Accessible")
                }
                HStack {
                    Image(systemName: "toilet")
                        .foregroundColor(.gray)
                    Text("Not Accessible")
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            .padding()
        }
    }
}
