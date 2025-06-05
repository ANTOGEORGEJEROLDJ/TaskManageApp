//
//  TaskDetailView.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI
import CoreData

struct TaskDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var task: Task

    @State private var selectedStatus: String
    @State private var timer: Timer?
    @State private var elapsedTime: TimeInterval = 0

    let statusOptions = ["Not Started", "In Progress", "Completed", "On Hold"]

    init(task: Task) {
        _task = ObservedObject(wrappedValue: task)
        _selectedStatus = State(initialValue: task.status ?? "Not Started")
        if let startTime = task.startTime {
            _elapsedTime = State(initialValue: Date().timeIntervalSince(startTime))
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Task Info")) {
                Text("Project: \(task.projectName ?? "N/A")")
                Text("Title: \(task.taskTitle ?? "N/A")")
                Text("Deadline: \(formattedDate(task.deadline))")
                Text("Category: \(task.category ?? "")")
            }

            Section(header: Text("Status")) {
                Picker("Select Status", selection: $selectedStatus) {
                    ForEach(statusOptions, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: selectedStatus) { newValue in
                    updateStatus(to: newValue)
                }
            }

            Section(header: Text("Timer")) {
                Text("Elapsed Time: \(formatTime(elapsedTime))")
            }
        }
        .navigationTitle("Task Details")
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func updateStatus(to newStatus: String) {
        task.status = newStatus

        switch newStatus {
        case "In Progress":
            task.startTime = Date()
            startTimer()
        case "Completed":
            task.endTime = Date()
            stopTimer()
            if let start = task.startTime, let end = task.endTime {
                task.duration = end.timeIntervalSince(start)
            }
        default:
            stopTimer()
        }

        do {
            try viewContext.save()
        } catch {
            print("Failed to update status: \(error)")
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let start = task.startTime {
                elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
