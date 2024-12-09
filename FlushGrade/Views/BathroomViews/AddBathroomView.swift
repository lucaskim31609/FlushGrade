import SwiftUI
import CoreLocation

struct AddBathroomView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: BathroomViewModel
    @State private var building = ""
    @State private var floor = 1
    @State private var gender = "All Gender"
    @State private var isAccessible = false
    @State private var location = ""
    @State private var address = ""  // New field for address
    @State private var isSearchingLocation = false
    @State private var errorMessage: String?
    @State private var latitude: Double = 42.3355  // Default to BC's coordinates
    @State private var longitude: Double = -71.1685
    
    let genderOptions = ["All Gender", "Men", "Women"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location")) {
                    TextField("Building Name", text: $building)
                    Stepper("Floor: \(floor)", value: $floor)
                    TextField("Specific Location (e.g., 'Near Stairs')", text: $location)
                    TextField("Address", text: $address)  // Address input field
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Details")) {
                    Picker("Gender", selection: $gender) {
                        ForEach(genderOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    Toggle("Wheelchair Accessible", isOn: $isAccessible)
                }
            }
            .navigationTitle("Add Bathroom")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveNewBathroom()
                }
                    .disabled(building.isEmpty || location.isEmpty)
            )
        }
    }
    
    private func saveNewBathroom() {
        isSearchingLocation = true
        errorMessage = nil
        
        let geocoder = CLGeocoder()
        
        // Add "Boston College" to make the address more specific
        let fullAddress = "\(address), Boston College, Chestnut Hill, MA"
        
        Task {
            do {
                let placemarks = try await geocoder.geocodeAddressString(fullAddress)
                guard let location = placemarks.first?.location?.coordinate else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not find location"])
                }
                
                let newBathroom = Bathroom(
                    id: nil,
                    building: building,
                    floor: floor,
                    gender: gender,
                    isAccessible: isAccessible,
                    location: self.location,
                    reviews: [],
                    latitude: location.latitude,
                    longitude: location.longitude,
                    address: address  // Store the original address
                )
                
                await viewModel.addBathroom(newBathroom)
                dismiss()
            } catch {
                errorMessage = "Error finding location: Please check the address"
            }
            isSearchingLocation = false
        }
    }
}
