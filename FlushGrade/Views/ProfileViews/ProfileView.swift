import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var bathroomViewModel = BathroomViewModel()
    @State private var reviewCount = 0
    
    var body: some View {
        NavigationView {
            if authViewModel.isAuthenticated {
                Form {
                    Section(header: Text("Account Information")) {
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(authViewModel.user?.email ?? "")
                                .foregroundColor(.secondary)
                        }
                        
                        if let creationDate = authViewModel.user?.metadata.creationDate {
                            HStack {
                                Text("Member Since")
                                Spacer()
                                Text(creationDate, style: .date)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Section(header: Text("Statistics")) {
                        HStack {
                            Text("Reviews Written")
                            Spacer()
                            Text("\(reviewCount)")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            authViewModel.signOut()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Sign Out")
                                Spacer()
                            }
                        }
                    }
                }
                .navigationTitle("Profile")
                .task {
                    if let userId = authViewModel.user?.uid {
                        reviewCount = await bathroomViewModel.getUserReviewCount(for: userId)
                    }
                }
                .onChange(of: authViewModel.user?.uid) { oldValue, newValue in
                    Task {
                        if let userId = newValue {
                            reviewCount = await bathroomViewModel.getUserReviewCount(for: userId)
                        }
                    }
                }
            } else {
                LoginView(authViewModel: authViewModel)
            }
        }
    }
}

// Preview Provider
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
