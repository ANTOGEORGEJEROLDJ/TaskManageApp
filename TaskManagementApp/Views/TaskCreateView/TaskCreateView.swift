//
//  TaskCreateView.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI
import CoreData

struct TaskCreateView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var projectName = ""
    @State private var taskTitle = ""
    @State private var deadline = Date()
    @State private var selectedCategory = "Development"
    @State private var showAlert = false

    let categories = ["Development", "Design", "Testing", "Documentation", "Research"]

    var body: some View {
        NavigationView {
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
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section {
                    Button(action: {
                        saveTask()
                    }) {
                        HStack {
                            Spacer()
                            Text("Create Task")
                                .bold()
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("Create Task")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Task Saved"),
                      message: Text("Successfully created task '\(taskTitle)'"),
                      dismissButton: .default(Text("OK")))
            }
        }
    }

    private func saveTask() {
        guard !projectName.isEmpty, !taskTitle.isEmpty else { return }

        let newTask = Task(context: viewContext)
        newTask.projectName = projectName
        newTask.taskTitle = taskTitle
        newTask.deadline = deadline
        newTask.category = selectedCategory

        do {
            try viewContext.save()
            showAlert = true
            projectName = ""
            taskTitle = ""
            deadline = Date()
            selectedCategory = "Development"
        } catch {
            print("❌ Failed to save task: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    TaskCreateView()
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
