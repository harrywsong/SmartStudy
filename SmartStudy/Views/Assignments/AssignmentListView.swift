import SwiftUI

struct AssignmentListView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                if store.assignments.isEmpty {
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
                            ForEach(store.assignments) { assignment in
                                AssignmentRowView(assignment: assignment)
                                    .environmentObject(store)
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
                    .environmentObject(store)
            }
        }
    }
}

struct AssignmentRowView: View {
    let assignment: Assignment
    @EnvironmentObject private var store: AppStore

    var priorityColor: Color {
        switch assignment.priority {
        case .high:
            return AppTheme.tagRed
        case .medium:
            return AppTheme.tagBeige
        case .low:
            return AppTheme.tagGreen
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                store.updateAssignmentCompletion(id: assignment.id, isCompleted: !assignment.isCompleted)
            }) {
                Image(systemName: assignment.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(assignment.isCompleted ? AppTheme.accent : AppTheme.textGray)
                    .font(.title3)
            }

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
    @EnvironmentObject private var store: AppStore
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
                        store.addAssignment(title: title, subject: subject, dueDate: dueDate, priority: priority)
                        dismiss()
                    }
                    .disabled(title.isEmpty || subject.isEmpty)
                }
            }
        }
    }
}

struct AssignmentListView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentListView()
            .environmentObject(AppStore())
    }
}
