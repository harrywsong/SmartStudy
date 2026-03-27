//
//  SmartStudyApp.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import SwiftUI
import SwiftData

@main
struct SmartStudyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    insertSampleData()
                }
        }
        .modelContainer(for: [Deck.self, Flashcard.self, Assignment.self])
    }
}
@MainActor
func insertSampleData() {
    let container = try! ModelContainer(for: Deck.self, Flashcard.self, Assignment.self)
    let context = container.mainContext

    // Prevent duplicate inserts
    let existing = try? context.fetch(FetchDescriptor<Deck>())
    if let existing, !existing.isEmpty { return }

    // Create sample deck
    let deck = Deck(name: "Biology", emoji: "🧬")

    let card1 = Flashcard(
        front: "What is photosynthesis?",
        back: "Process plants use to convert sunlight into energy.",
        hint: "Think about plants and sunlight 🌱"
    )

    let card2 = Flashcard(
        front: "What is mitosis?",
        back: "Cell division producing two identical cells.",
        hint: "It helps organisms grow"
    )

    //sample deck #2
    let deck2 = Deck(name: "Math", emoji: "➗")

    let mathCard1 = Flashcard(
        front: "What is 2 + 2?",
        back: "4",
        hint: "Basic addition"
    )

    let mathCard2 = Flashcard(
        front: "What is derivative of x^2?",
        back: "2x",
        hint: "Power rule"
    )

    deck2.cards = [mathCard1, mathCard2]
    
    deck.cards = [card1, card2]

    context.insert(deck)
    context.insert(deck2)
    try? context.save()
}
