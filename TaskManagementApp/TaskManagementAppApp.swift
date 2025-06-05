//
//  TaskManagementAppApp.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI

@main
struct TaskManagementAppApp: App {
    var body: some Scene {
        WindowGroup {
            LoginScreen()
        }
    }
}







//@main
//struct TaskManagementAppApp: App {
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//            ProjectListView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}
