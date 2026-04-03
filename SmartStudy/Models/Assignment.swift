import Foundation

enum Priority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct Assignment: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var subject: String
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        subject: String,
        dueDate: Date,
        priority: Priority = .medium,
        isCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.subject = subject
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
