//
//  AssignmentListView.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import SwiftUI
import SwiftData

struct AssignmentListView: View {
    @Query(sort: \Assignment.dueDate) var assignments: [Assignment]
    @Environment(\.modelContext) private var context
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                if assignments.isEmpty {
                    VStack(spacing: 12) {
                        Text("✅")
                            .font(.system(size: 60))
                        Text("No assignments yet")
                            .font(.title2)
                            .foregroundColor(AppTheme.textDark)
                        Text("Tap + to add one")
                            .foregroundColor(AppTheme.textGray)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(assignments) { assignment in
                                AssignmentRowView(assignment: assignment)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Assignments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(AppTheme.accent)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddAssignmentSheet()
            }
        }
    }
}

struct AssignmentRowView: View {
    let assignment: Assignment
    @Environment(\.modelContext) private var context

    var priorityColor: Color {
        switch assignment.priority {
        case .high:   return AppTheme.tagRed
        case .medium: return AppTheme.tagBeige
        case .low:    return AppTheme.tagGreen
        }
    }

    var body: some View {
        HStack(spacing: 12) {

            // Checkmark button
            Button(action: {
                assignment.isCompleted.toggle()
                try? context.save()
            }) {
                Image(systemName: assignment.isCompleted
                      ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(assignment.isCompleted
                                     ? AppTheme.accent : AppTheme.textGray)
                    .font(.title3)
            }

            // Text info
            VStack(alignment: .leading, spacing: 4) {
                Text(assignment.title)
                    .font(.headline)
                    .foregroundColor(AppTheme.textDark)
                    .strikethrough(assignment.isCompleted)
                Text(assignment.subject)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textGray)
                Text("Due: \(assignment.dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundColor(AppTheme.textGray)
            }

            Spacer()

            // Priority badge
            Text(assignment.priority.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(priorityColor)
                .foregroundColor(AppTheme.textDark)
                .cornerRadius(8)
        }
        .padding()
        .background(AppTheme.cardBG)
        .cornerRadius(AppTheme.cornerMedium)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct AddAssignmentSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var subject = ""
    @State private var dueDate = Date()
    @State private var priority: Priority = .medium

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Subject", text: $subject)
                }
                Section("Due Date") {
                    DatePicker("Due", selection: $dueDate, displayedComponents: .date)
                }
                Section("Priority") {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("New Assignment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let a = Assignment(
                            title: title,
                            subject: subject,
                            dueDate: dueDate,
                            priority: priority
                        )
                        context.insert(a)
                        try? context.save()
                        dismiss()
                    }
                    .disabled(title.isEmpty || subject.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AssignmentListView()
}
