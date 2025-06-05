//
//  LoginScreen.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedRole: String = ""
    
    @State private var navigateToProfile = false
    @State private var showRoleSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.opacity(0.95).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Image("LoginBackgroundImage")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .frame(width: 200, height: 200)
                            .padding(.top)
                        
                        Text("Login to continue your fitness journey")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.black.opacity(0.6))
//                            .multilineTextAlignment(.center)
                            .padding(.top,-20)
                        
                        VStack(spacing: 15) {
                            CustomTextField(icon: "person.fill", placeHolder: "User Name", text: $userName)
                            CustomTextField(icon: "envelope.fill", placeHolder: "Email", text: $email)
                            CustomTextField(icon: "lock.fill", placeHolder: "Password", text: $password)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        
                        // Select Role Button
                        Button(action: {
                            showRoleSheet = true
                        }) {
                            Text("Select the Role")
                                .padding()
                                .frame(width: 240)
                                .bold()
                                .foregroundColor(.black)
                                .background(Color.blue.opacity(0.4))
                                .cornerRadius(15)
                        }
                        
                        // Show selected role
                        if !selectedRole.isEmpty {
                            Text("Selected Role: \(selectedRole)")
                                .foregroundColor(.gray)
                                .padding(.bottom, 10)
                        }
                        
                        // NavigationLink to ProfileScreen
                        NavigationLink(destination: TaskCreateView(), isActive: $navigateToProfile) {
                            EmptyView()
                        }
                        
                        // Login Button
                        Button(action: {
                            if !selectedRole.isEmpty {
                                navigateToProfile = true
                            }
                        }) {
                            Text("Login")
                                .padding()
                                .frame(width: 240)
                                .bold()
                                .foregroundColor(.black)
                                .background(Color.blue.opacity(0.4))
                                .cornerRadius(15)
                        }.padding(.top,-20)
                        
                        // Social Buttons
                        HStack {
                            Button(action: {
                                // Google login action
                            }) {
                                Image("google")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }
                            .padding()
                            .frame(width: 90, height: 70)
                            .background(Color.white.opacity(0.8))
                            .shadow(radius: 1)
                            .cornerRadius(20)
                            
                            Spacer()
                            
                            Button(action: {
                                // Apple login action
                            }) {
                                Image("apple")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            .padding()
                            .frame(width: 90, height: 70)
                            .background(Color.white.opacity(0.8))
                            .shadow(radius: 1)
                            .cornerRadius(20)
                        }
                        .padding()
                        .frame(width: 250)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .sheet(isPresented: $showRoleSheet) {
                VStack(spacing: 20) {
                    Text("Select Your Role")
                        .font(.headline)
                        .padding(.top)
                    
                    Button("Manager") {
                        selectedRole = "Manager"
                        showRoleSheet = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                    Button("Developer") {
                        selectedRole = "Developer"
                        showRoleSheet = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding()
                .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    LoginScreen()
}
