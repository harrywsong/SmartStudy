import Foundation

struct Deck: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var colorHex: String
    var emoji: String
    var createdAt: Date
    var cards: [Flashcard] = []

    init(
        id: UUID = UUID(),
        name: String,
        colorHex: String = "#B7D5C8",
        emoji: String = "📚",
        createdAt: Date = Date(),
        cards: [Flashcard] = []
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.emoji = emoji
        self.createdAt = createdAt
        self.cards = cards
    }

    var masteredCount: Int {
        cards.filter { $0.learningState == .mastered }.count
    }

    var masteryPercentage: Double {
        guard !cards.isEmpty else { return 0 }
        return Double(masteredCount) / Double(cards.count)
    }
}
