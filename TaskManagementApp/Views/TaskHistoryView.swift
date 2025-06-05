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
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(inProgressTasks) { task in
                    TaskHistoryCard(task: task)
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom))
                        .animation(.spring(), value: inProgressTasks.count)
                }
            }
            .padding(.top)
        }
        .background(LinearGradient(colors: [.white, .blue.opacity(0.05)], startPoint: .top, endPoint: .bottom))
        .navigationTitle("🔥 In Progress Tasks")
    }
}

struct TaskHistoryCard: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.projectName ?? "No Project")
                        .font(.headline)
                    Text(task.taskTitle ?? "No Title")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("⏳")
                        .font(.title2)
                    Text(formatDate(task.deadline))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            // Details
            HStack {
                Label(task.category ?? "N/A", systemImage: "tag.fill")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                
                Spacer()
                
                if let start = task.startTime {
                    Label("Started", systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(.orange)
                    Text(formatDate(start))
                        .font(.caption2)
                }
            }

            if task.duration > 0 {
                HStack {
                    Text("⏱ Duration:")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text(formatTime(task.duration))
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.blue.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
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
