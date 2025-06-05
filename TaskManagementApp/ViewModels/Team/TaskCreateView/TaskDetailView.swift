//
//  TaskDetailView.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI
import CoreData

struct TaskDetailView: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var selectedStatus: String
    @State private var timer: Timer?
    @State private var elapsedTime: TimeInterval = 0
    
    let statusOptions = ["Not Started", "In Progress", "Completed", "On Hold"]
    
    init(task: Task) {
        self.task = task
        _selectedStatus = State(initialValue: task.status ?? "Not Started")
        if let startTime = task.startTime {
            _elapsedTime = State(initialValue: Date().timeIntervalSince(startTime))
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Header
                VStack(alignment: .leading, spacing: 6) {
                    Text(task.taskTitle ?? "Task Title")
                        .font(.subheadline)
                        .bold()
                    
                    Text("Deadline: \(formattedDate(task.deadline))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    statusBadge
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground)))
                .shadow(radius: 2)
                
                // MARK: - Details
                detailCard
                
                // MARK: - Status Picker
                VStack(alignment: .leading, spacing: 12) {
                    Text("Update Status")
                        .font(.headline)
                    Picker("Select Status", selection: $selectedStatus) {
                        ForEach(statusOptions, id: \.self) { status in
                            Text(status)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 300)
                    .onChange(of: selectedStatus, perform: updateStatus)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
                .shadow(radius: 2)
                
                // MARK: - Timer View
                VStack(alignment: .leading, spacing: 10) {
                    Text("Elapsed Time")
                        .font(.headline)
                    Text(formatTime(elapsedTime))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(radius: 2)
                )
            }
            .padding()
        }
        .navigationTitle("Task Details")
        .onDisappear { timer?.invalidate() }
        .onAppear {
            if selectedStatus == "In Progress" {
                startTimer()
            }
        }
    }
    
    // MARK: - Task Info Card
    var detailCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow(label: "Project", value: task.projectName ?? "N/A", icon: "folder")
            infoRow(label: "Category", value: task.category ?? "N/A", icon: "tag")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(radius: 4)
    }
    
    // MARK: - Status Badge
    var statusBadge: some View {
        Text(selectedStatus)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor(for: selectedStatus))
            .foregroundColor(.white)
            .cornerRadius(20)
    }
    
    // MARK: - Info Row
    func infoRow(label: String, value: String, icon: String) -> some View {
        HStack {
            Label(label, systemImage: icon)
                .foregroundColor(.blue)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
    
    // MARK: - Status Handling
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
        saveContext()
    }
    
    // MARK: - Timer Logic
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
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }
    
    private func formattedDate(_ date: Date?) -> String {
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
    
    private func statusColor(for status: String) -> Color {
        switch status {
        case "Completed": return .green
        case "In Progress": return .orange
        case "On Hold": return .gray
        default: return .blue
        }
    }
}
//struct TaskDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.preview.container.viewContext
//        let sample = Task(context: context)
//        sample.projectName = "iOS App"
//        sample.taskTitle = "Design Login UI"
//        sample.deadline = Date()
//        sample.category = "Design"
//        sample.status = "In Progress"
//        sample.startTime = Date().addingTimeInterval(-300)
//        return NavigationView {
//            TaskDetailView(task: sample)
//                .environment(\.managedObjectContext, context)
//        }
//    }
//}
