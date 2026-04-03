import SwiftUI
import Combine

@main
struct SmartStudyApp: App {
    @StateObject private var store = AppStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

final class AppStore: ObservableObject {
    @Published var decks: [Deck] = [] {
        didSet { save() }
    }

    @Published var assignments: [Assignment] = [] {
        didSet { save() }
    }

    private let fileURL: URL

    init() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory())
        self.fileURL = documents.appendingPathComponent("smartstudy_data.json")

        load()

        if decks.isEmpty {
            insertSampleData()
        }
    }

    func insertSampleData() {
        let biologyCards = [
            Flashcard(
                front: "What is photosynthesis?",
                back: "Process plants use to convert sunlight into energy.",
                hint: "Think about plants and sunlight 🌱"
            ),
            Flashcard(
                front: "What is mitosis?",
                back: "Cell division producing two identical cells.",
                hint: "It helps organisms grow"
            )
        ]

        let mathCards = [
            Flashcard(front: "What is 2 + 2?", back: "4", hint: "Basic addition"),
            Flashcard(front: "What is derivative of x^2?", back: "2x", hint: "Power rule")
        ]

        decks = [
            Deck(name: "Biology", emoji: "🧬", cards: biologyCards),
            Deck(name: "Math", emoji: "➗", cards: mathCards)
        ]
    }

    func addDeck(name: String, emoji: String) {
        decks.append(Deck(name: name, emoji: emoji.isEmpty ? "📚" : emoji))
    }

    func updateDeck(id: UUID, name: String, emoji: String) {
        guard let index = decks.firstIndex(where: { $0.id == id }) else { return }
        decks[index].name = name
        decks[index].emoji = emoji.isEmpty ? "📚" : emoji
    }

    func deleteDecks(at offsets: IndexSet) {
        decks.remove(atOffsets: offsets)
    }

    func addCard(deckID: UUID, front: String, back: String, hint: String) {
        guard let deckIndex = decks.firstIndex(where: { $0.id == deckID }) else { return }
        decks[deckIndex].cards.append(Flashcard(front: front, back: back, hint: hint))
    }

    func updateCard(deckID: UUID, cardID: UUID, front: String, back: String, hint: String) {
        guard let deckIndex = decks.firstIndex(where: { $0.id == deckID }),
              let cardIndex = decks[deckIndex].cards.firstIndex(where: { $0.id == cardID }) else { return }

        decks[deckIndex].cards[cardIndex].front = front
        decks[deckIndex].cards[cardIndex].back = back
        decks[deckIndex].cards[cardIndex].hint = hint
    }

    func deleteCard(deckID: UUID, cardID: UUID) {
        guard let deckIndex = decks.firstIndex(where: { $0.id == deckID }) else { return }
        decks[deckIndex].cards.removeAll(where: { $0.id == cardID })
    }

    func setLearningState(deckID: UUID, cardID: UUID, state: LearningState) {
        guard let deckIndex = decks.firstIndex(where: { $0.id == deckID }),
              let cardIndex = decks[deckIndex].cards.firstIndex(where: { $0.id == cardID }) else { return }

        decks[deckIndex].cards[cardIndex].learningState = state
    }

    func addAssignment(title: String, subject: String, dueDate: Date, priority: Priority) {
        assignments.append(Assignment(title: title, subject: subject, dueDate: dueDate, priority: priority))
        assignments.sort { $0.dueDate < $1.dueDate }
    }

    func updateAssignmentCompletion(id: UUID, isCompleted: Bool) {
        guard let index = assignments.firstIndex(where: { $0.id == id }) else { return }
        assignments[index].isCompleted = isCompleted
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let payload = try? JSONDecoder().decode(PersistencePayload.self, from: data) else { return }
        decks = payload.decks
        assignments = payload.assignments
    }

    private func save() {
        let payload = PersistencePayload(decks: decks, assignments: assignments)
        guard let data = try? JSONEncoder().encode(payload) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }
}

private struct PersistencePayload: Codable {
    var decks: [Deck]
    var assignments: [Assignment]
}
