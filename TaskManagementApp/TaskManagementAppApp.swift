//
//  TaskManagementAppApp.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import CryptoKit
import SwiftUI
import CoreData
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct TaskManagementApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared
    
    @StateObject private var session = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            if session.isLoggedIn {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(session)  // inject once here
            } else {
                LoginScreen()
                    .environmentObject(session)  // inject here too
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}


final class SessionManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var role = ""
    @Published var email = ""
    @Published var userName = ""
    
    func login(userName: String, role: String, email: String) {
        self.userName = userName
        self.role = role
        self.email = email
        self.isLoggedIn = true
    }
    
    func logout() {
        self.isLoggedIn = false
        self.role = ""
        self.userName = ""
        self.email = ""
    }
}
