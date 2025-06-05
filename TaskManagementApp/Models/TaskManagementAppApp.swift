//
//  TaskManagementAppApp.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI
import CoreData

@main
struct TaskManagementApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject private var session = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            if session.isLoggedIn {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(session)
            } else {
                LoginScreen()
                    .environmentObject(session)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

final class SessionManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var role = ""
    @Published var userName = ""
    
    func login(userName: String, role: String) {
        self.userName = userName
        self.role = role
        self.isLoggedIn = true
    }
    
    func logout() {
        self.isLoggedIn = false
        self.role = ""
        self.userName = ""
    }
}
