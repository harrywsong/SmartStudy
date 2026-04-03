import Foundation

enum LearningState: String, Codable {
    case new
    case learning
    case mastered
}

struct Flashcard: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var front: String
    var back: String
    var hint: String
    var learningState: LearningState
    var createdAt: Date

    init(
        id: UUID = UUID(),
        front: String,
        back: String,
        hint: String = "",
        learningState: LearningState = .new,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.front = front
        self.back = back
        self.hint = hint
        self.learningState = learningState
        self.createdAt = createdAt
    }
}
