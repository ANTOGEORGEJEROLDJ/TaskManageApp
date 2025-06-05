//
//  profileScreen.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionManager  // Use the app-wide session manager

    var body: some View {
        VStack(spacing: 30) {
            Text("Profile")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Username:")
                        .bold()
                    Spacer()
                    Text(session.userName)
                }
                HStack {
                    Text("Email:")
                        .bold()
                    Spacer()
                    Text(session.email)
                }
                HStack {
                    Text("Role:")
                        .bold()
                    Spacer()
                    Text(session.role)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.15))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()

            Button(action: {
                session.logout()
            }) {
                Text("Logout")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            Spacer()
        }
    }
}
