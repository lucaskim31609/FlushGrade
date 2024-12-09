import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    
    var body: some View {
        Form {
            Section(header: Text("Credentials")) {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textContentType(isSignUp ? .newPassword : .password)
            }
            
            if let errorMessage = authViewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            
            Section {
                Button(action: {
                    Task {
                        if isSignUp {
                            await authViewModel.signUp(email: email, password: password)
                        } else {
                            await authViewModel.signIn(email: email, password: password)
                        }
                    }
                }) {
                    HStack {
                        Spacer()
                        if authViewModel.isLoading {
                            ProgressView()
                        } else {
                            Text(isSignUp ? "Sign Up" : "Log In")
                        }
                        Spacer()
                    }
                }
                .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                
                Button(action: {
                    isSignUp.toggle()
                    email = ""
                    password = ""
                    authViewModel.errorMessage = nil
                }) {
                    Text(isSignUp ? "Already have an account? Log in" : "Don't have an account? Sign up")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle(isSignUp ? "Sign Up" : "Log In")
    }
}
