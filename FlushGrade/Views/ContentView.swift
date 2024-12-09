import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BathroomViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                BathroomListView(viewModel: viewModel)
            }
            .tabItem {
                Label("Bathrooms", systemImage: "list.bullet")
            }
            
            NavigationView {
                MapView(viewModel: viewModel)
                    .navigationTitle("Map")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .task {
            await viewModel.fetchBathrooms()
        }
    }
}
