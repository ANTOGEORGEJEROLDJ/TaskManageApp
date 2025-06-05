//
//  LoginScreen.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI
import CoreData

// MARK: - LoginScreen
struct LoginScreen: View {
    @EnvironmentObject var session: SessionManager
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = ""
    @State private var showRoleSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Login to Task Management App")
                    .font(.title2)
                    .bold()
                    .padding(.top, 50)
                
                CustomTextField(icon: "person.fill", placeHolder: "User Name", text: $userName)
                CustomTextField(icon: "envelope.fill", placeHolder: "Email", text: $email)
                CustomTextField(icon: "lock.fill", placeHolder: "Password", text: $password)
                
                Button("Select Role") {
                    showRoleSheet = true
                }
                .padding()
                .background(Color.blue.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(12)
                
                if !selectedRole.isEmpty {
                    Text("Selected Role: \(selectedRole)")
                        .foregroundColor(.gray)
                }
                
                Button("Login") {
                    guard !userName.isEmpty && !selectedRole.isEmpty else { return }
                    session.login(userName: userName, role: selectedRole, email: email)
                }
                .disabled(userName.isEmpty || selectedRole.isEmpty)
                .padding()
                .background(userName.isEmpty || selectedRole.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Spacer()
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
                    
                    Button("Developer") {
                        selectedRole = "Developer"
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
