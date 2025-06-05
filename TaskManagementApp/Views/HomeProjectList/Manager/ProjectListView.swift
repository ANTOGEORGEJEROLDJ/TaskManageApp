//
//  ProjectList.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//


import SwiftUI
import CoreData

// MARK: - ProjectListView
struct ProjectListView: View {
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: true)]
    ) var tasks: FetchedResults<Task>
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                NavigationLink(destination: TaskDetailView(task: task)) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(task.projectName ?? "No Project")
                            .font(.headline)
                        Text(task.taskTitle ?? "No Title")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Label(task.category ?? "Category", systemImage: "tag.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Text(formatDate(task.deadline))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("Project Tasks")
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
