//
//  TaskCreateView.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI
import CoreData

// MARK: - TaskCreateView
struct TaskCreateView: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var session: SessionManager
    
    @State private var projectName = ""
    @State private var taskTitle = ""
    @State private var deadline = Date()
    @State private var selectedCategory = "Development"
    @State private var showAlert = false
    
    let categories = ["Development", "Design", "Testing", "Documentation", "Research"]
    
    var body: some View {
        Form {
            Section(header: Text("Project Details")) {
                TextField("Project Name", text: $projectName)
                TextField("Task Title", text: $taskTitle)
            }
            Section(header: Text("Deadline")) {
                DatePicker("Select Date & Time", selection: $deadline, displayedComponents: [.date, .hourAndMinute])
            }
            Section(header: Text("Category")) {
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { cat in
                        Text(cat)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Section {
                Button("Create Task") {
                    saveTask()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
        }
        .navigationTitle("Create Task")
        .alert("Task Saved", isPresented: $showAlert, actions: {
            Button("OK") {}
        }, message: {
            Text("Successfully created task '\(taskTitle)'")
        })
    }
    
    private func saveTask() {
        guard !projectName.isEmpty, !taskTitle.isEmpty else { return }
        let newTask = Task(context: viewContext)
        newTask.projectName = projectName
        newTask.taskTitle = taskTitle
        newTask.deadline = deadline
        newTask.category = selectedCategory
        newTask.status = "Not Started"
        newTask.duration = 0
        newTask.id = UUID()
        
        do {
            try viewContext.save()
            showAlert = true
            projectName = ""
            taskTitle = ""
            deadline = Date()
            selectedCategory = "Development"
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }
}
