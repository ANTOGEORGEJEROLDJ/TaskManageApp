//
//  ProjectList.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//


import SwiftUI
import CoreData

struct ProjectListView: View {
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: true)]
    ) var tasks: FetchedResults<Task>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(tasks) { task in
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        TaskCard(task: task)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Project Tasks")
    }
}

struct TaskCard: View {
    let task: Task

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(task.projectName ?? "No Project")
                    .font(.title3)
                    .bold()
                Spacer()
                Text(formatDate(task.deadline))
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Text(task.taskTitle ?? "No Title")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Label(task.category ?? "Category", systemImage: "tag.fill")
                    .font(.caption)
                    .padding(6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Spacer()
                
                if let status = task.status {
                    Text(status)
                        .font(.caption2)
                        .foregroundColor(status == "Completed" ? .green : .orange)
                        .padding(6)
                        .background(status == "Completed" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
