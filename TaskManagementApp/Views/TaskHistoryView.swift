//
//  TaskHistoryView.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI
import CoreData

struct TaskHistoryView: View {
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: true)],
        predicate: NSPredicate(format: "status == %@", "In Progress")
    ) var inProgressTasks: FetchedResults<Task>

    var body: some View {
        NavigationView {
            List {
                ForEach(inProgressTasks) { task in
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Project: \(task.projectName ?? "N/A")")
                            .font(.headline)

                        Text("Task: \(task.taskTitle ?? "N/A")")
                            .font(.subheadline)

                        HStack {
                            Label("Category: \(task.category ?? "N/A")", systemImage: "tag")
                                .font(.caption)
                            Spacer()
                            Label("Deadline: \(formatDate(task.deadline))", systemImage: "calendar")
                                .font(.caption)
                        }

                        if let status = task.status {
                            Text("Status: \(status)")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }

                        if let startTime = task.startTime {
                            Text("Started At: \(formatDate(startTime))")
                                .font(.caption2)
                        }

                        if task.duration > 0.0 {
                            Text("Duration: \(Int(task.duration)) seconds")
                                .font(.caption2)
                                .foregroundColor(.green)
                        }

                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("In Progress Tasks")
        }
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
