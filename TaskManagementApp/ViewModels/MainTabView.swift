//
//  MainTabView.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI

// MARK: - MainTabView (After login)
struct MainTabView: View {
    @EnvironmentObject var session: SessionManager  // or UserSessionManager if you renamed it
    
    var body: some View {
        TabView {
            if session.role == "Manager" {
                NavigationView {
                    TaskCreateView()
                }
                .tabItem {
                    Label("Create Task", systemImage: "plus.circle")
                }
            } else {
                NavigationView {
                    ProjectListView()
                }
                .tabItem {
                    Label("Tasks", systemImage: "list.bullet")
                }
            }
            
            NavigationView {
                TaskHistoryView()
            }
            .tabItem {
                Label("Task History", systemImage: "clock")
            }
            
            NavigationView {
                ProfileView()
                .environmentObject(session)
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}
