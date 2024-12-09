import SwiftUI

struct BathroomListView: View {
    let bathrooms: [Bathroom]
    @StateObject private var viewModel = BathroomViewModel()
    @State private var searchText = ""
    @State private var selectedBuilding: String?
    @State private var showingAddBathroom = false
    
    var filteredBathrooms: [Bathroom] {
        viewModel.filterBathrooms(by: selectedBuilding, searchText: searchText)
    }
    
    var buildings: [String] {
        Array(Set(bathrooms.map { $0.building })).sorted()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "All",
                        isSelected: selectedBuilding == nil,
                        action: { selectedBuilding = nil }
                    )
                    
                    ForEach(buildings, id: \.self) { building in
                        FilterChip(
                            title: building,
                            isSelected: selectedBuilding == building,
                            action: { selectedBuilding = building }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            List {
                ForEach(filteredBathrooms) { bathroom in
                    NavigationLink(destination: BathroomDetailView(bathroom: bathroom)) {
                        BathroomRowView(bathroom: bathroom)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("BC Bathrooms")
        .searchable(text: $searchText, prompt: "Search bathrooms...")
        .navigationBarItems(trailing:
            Button(action: {
                showingAddBathroom = true
            }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $showingAddBathroom) {
            AddBathroomView()
        }
    }
}
