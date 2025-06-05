//
//  profileScreen.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Profile Header
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                        .padding(.top, 40)

                    Text(session.userName)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)

                    Text(session.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 20)

                // Info Card
                VStack(spacing: 16) {
                    ProfileRow(title: "Username", value: session.userName, icon: "person")
                    ProfileRow(title: "Email", value: session.email, icon: "envelope")
                    ProfileRow(title: "Role", value: session.role, icon: "person.text.rectangle")
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                .padding(.horizontal)

                Spacer()

                // Logout Button
                Button(action: {
                    session.logout()
                }) {
                    Label("Logout", systemImage: "arrow.backward.circle.fill")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [.red, .pink], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(16)
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
        .background(LinearGradient(colors: [.white, .blue.opacity(0.05)], startPoint: .top, endPoint: .bottom))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileRow: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.body)
                    .bold()
            }
            Spacer()
        }
    }
}
