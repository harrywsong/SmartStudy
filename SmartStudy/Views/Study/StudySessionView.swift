//
//  StudySessionView.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import SwiftUI
import SwiftData

struct StudySessionView: View {
    let deck: Deck

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var currentIndex: Int = 0
    @State private var isFlipped: Bool = false
    @State private var correctCount: Int = 0
    @State private var sessionDone: Bool = false

    var cards: [Flashcard] { deck.cards }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            if sessionDone {

                // End screen
                VStack(spacing: 24) {
                    Spacer()

                    Text("🎉")
                        .font(.system(size: 64))

                    Text("Session Complete!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textDark)

                    Text("\(correctCount) / \(cards.count) correct")
                        .font(.title3)
                        .foregroundColor(AppTheme.textGray)

                    Spacer()

                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.accent)
                    .foregroundColor(.white)
                    .cornerRadius(AppTheme.cornerMedium)
                    .padding(.horizontal)
                }

            } else {

                // Study screen
                VStack(spacing: 24) {

                    // Header row
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(AppTheme.textGray)
                                .font(.title3)
                        }
                        Spacer()
                        Text("Card \(currentIndex + 1) of \(cards.count)")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textGray)
                    }
                    .padding(.horizontal)

                    // Progress bar
                    ProgressView(value: Double(currentIndex), total: Double(cards.count))
                        .tint(AppTheme.accent)
                        .padding(.horizontal)

                    Spacer()

                    FlashCardView(card: cards[currentIndex], isFlipped: $isFlipped)

                    Spacer()

                    // Buttons only appear after flipping. Should we change?
                    if isFlipped {
                        HStack(spacing: 16) {
                            Button(action: { advance(knew: false) }) {
                                Label("Miss", systemImage: "xmark")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppTheme.tagRed)
                                    .foregroundColor(AppTheme.textDark)
                                    .cornerRadius(AppTheme.cornerMedium)
                            }
                            Button(action: { advance(knew: true) }) {
                                Label("Got It", systemImage: "checkmark")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppTheme.tagGreen)
                                    .foregroundColor(AppTheme.textDark)
                                    .cornerRadius(AppTheme.cornerMedium)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationBarHidden(true)
    }

    func advance(knew: Bool) {
        if knew {
            correctCount += 1
            cards[currentIndex].learningState = .mastered
        } else {
            cards[currentIndex].learningState = .learning
        }

        try? context.save()

        if currentIndex + 1 >= cards.count {
            sessionDone = true
        } else {
            currentIndex += 1
            isFlipped = false
        }
    }
}

// THIS IS JUST SO YOU CAN PREVIEW WHAT IT LOOKS LIKE WITHOUT ERROR
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Deck.self, configurations: config)
    let deck = Deck(name: "Biology", colorHex: "#B7D5C8", emoji: "🧬")
    let card1 = Flashcard(front: "What is photosynthesis?", back: "Converting sunlight into energy.", hint: "Think about plants.")
    let card2 = Flashcard(front: "What is mitosis?", back: "Cell division producing two identical cells.", hint: "Think about reproduction.")
    deck.cards = [card1, card2]
    container.mainContext.insert(deck)
    return StudySessionView(deck: deck)
        .modelContainer(container)
}
