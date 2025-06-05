//
//  TaskHistoryView.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI
import CoreData

// MARK: - TaskHistoryView
struct TaskHistoryView: View {
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: true)],
        predicate: NSPredicate(format: "status == %@", "In Progress")
    ) var inProgressTasks: FetchedResults<Task>
    
    var body: some View {
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
                        Text(formatDate(task.deadline))
                            .font(.caption)
                    }
                    if let start = task.startTime {
                        Text("Started At: \(formatDate(start))")
                            .font(.caption2)
                    }
                    if task.duration > 0 {
                        Text("Duration: \(formatTime(task.duration))")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("In Progress Tasks")
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let mins = Int(time) / 60
        let secs = Int(time) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
