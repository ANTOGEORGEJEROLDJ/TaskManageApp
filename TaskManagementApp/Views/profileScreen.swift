//
//  profileScreen.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI

struct ProfileScreen: View {
    var userName: String
    var role: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome, \(userName)")
                .font(.title)
                .bold()
            
            Text("You are logged in as a \(role)")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
        .navigationTitle("Profile")
    }
}
