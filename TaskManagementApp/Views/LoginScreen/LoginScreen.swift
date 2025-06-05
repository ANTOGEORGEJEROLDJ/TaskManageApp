//
//  LoginScreen.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI
import CoreData
import FirebaseCore
import FirebaseAuth
import AuthenticationServices
import CryptoKit


// MARK: - LoginScreen
struct LoginScreen: View {
    @EnvironmentObject var session: SessionManager
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = ""
    @State private var showRoleSheet = false
    @State private var errorMessage = ""
    @State private var isAuthenticated = false
    @State private var isSignedIn = false
    
    private let appleLoginManager = AppleSignInManager()
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 20) {
                    
                    Image("LoginBackgroundImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.top, -30)
                    
                    
                    Text("Login to Task Management App")
                        .font(.subheadline)
                        .bold()
                        .padding(.top, -30)
                        .background(Color.black.opacity(0.7))
                    
                        Group{
                            VStack(spacing: 13){
                            
                            CustomTextField(icon: "person.fill", placeHolder: "User Name", text: $userName)
                            CustomTextField(icon: "envelope.fill", placeHolder: "Email", text: $email)
                            CustomTextField(icon: "lock.fill", placeHolder: "Password", text: $password)
                            
                        }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }.padding(.top, -20)
                    
                    Group{
                        
                        Button("Select Role") {
                            showRoleSheet = true
                        }
                        .frame(width: 258, height: 22)
                        .padding()
                        .bold()
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.black.opacity(0.7))
                        .font(.headline)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        
                        if !selectedRole.isEmpty {
                            Text("Selected Role: \(selectedRole)")
                                .foregroundColor(.gray)
                        }
                        
                        Button("Login") {
                            guard !userName.isEmpty && !selectedRole.isEmpty else { return }
                            session.login(userName: userName, role: selectedRole, email: email)
                        }
                        .frame(width: 258, height: 22)
                        .padding()
                        .bold()
                        .background(userName.isEmpty || selectedRole.isEmpty ? Color.gray : Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .disabled(userName.isEmpty || selectedRole.isEmpty)
                        .font(.headline)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                                             
                       
                    }
                    Spacer()
                    
                    HStack (spacing: 20){
                        
                        NavigationLink(destination: MainTabView(), isActive: $isSignedIn) {
                            EmptyView()
                        }

                            Button(action: {
                                
                                handleSignIn()
                                
                            }){
                                Image("google")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 19, height: 19)
                            }
                            .frame(width: 70, height: 22)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue.opacity(0.1))
                            .font(.headline)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            
                            
                            Button(action:{
                                
                                appleLoginManager.startSignInWithAppleFlow()

                                
                            }){
                                Image("apple")
                                    .resizable()
                                    .scaledToFit()
                                
                            }
                            .frame(width: 70, height: 22)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue.opacity(0.1))
                            .font(.headline)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }.padding(.top,-30)
                    
                }
                .padding()
                .navigationTitle("Login")
                .sheet(isPresented: $showRoleSheet) {
                    VStack(spacing: 20) {
                        Text("Select Your Role")
                            .font(.headline)
                            .padding(.top)
                        Button("Manager") {
                            selectedRole = "Manager"
                            showRoleSheet = false
                        }
                        .buttonStyle(RoleButtonStyle(color: .blue))
                        
                        Button("Team") {
                            selectedRole = "Team"
                            showRoleSheet = false
                        }
                        .buttonStyle(RoleButtonStyle(color: .green))
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
    func handleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Missing Firebase Client ID"
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            errorMessage = "No rootViewController available"
            return
        }


        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                self.errorMessage = "Google Sign-In failed: \(error.localizedDescription)"
                return
            }

            guard let result = result else {
                self.errorMessage = "Sign-in result was nil"
                return
            }

            guard let idToken = result.user.idToken?.tokenString else {
                self.errorMessage = "Missing ID Token"
                return
            }

            let accessToken = result.user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.errorMessage = "Firebase Sign-In failed: \(error.localizedDescription)"
                } else {
                    self.isSignedIn = true
                    print("Firebase Sign-In Success: \(authResult?.user.email ?? "No Email")")
                }
            }
        }
    }
 
}

struct RoleButtonStyle: ButtonStyle {
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}


struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .environmentObject(SessionManager())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
