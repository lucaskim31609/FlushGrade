import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BathroomViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                BathroomListView(bathrooms: viewModel.bathrooms)
            }
            .tabItem {
                Label("Bathrooms", systemImage: "list.bullet")
            }
            
            Text("Map View Coming Soon!")
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            Text("Profile Coming Soon!")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .task {
            await viewModel.fetchBathrooms()
        }
    }
}
