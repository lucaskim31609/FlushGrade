import SwiftUI

struct AddBathroomView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = BathroomViewModel()
    
    @State private var building = ""
    @State private var floor = 1
    @State private var gender = "All Gender"
    @State private var isAccessible = false
    @State private var location = ""
    
    let genderOptions = ["All Gender", "Men", "Women"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location")) {
                    TextField("Building Name", text: $building)
                    Stepper("Floor: \(floor)", value: $floor)
                    TextField("Specific Location (e.g., 'Near Stairs')", text: $location)
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
        Task {
            let newBathroom = Bathroom(
                id: nil,
                building: building,
                floor: floor,
                gender: gender,
                isAccessible: isAccessible,
                location: location,
                reviews: []
            )
            
            await viewModel.addBathroom(newBathroom)
            dismiss()
        }
    }
}
