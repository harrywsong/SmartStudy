import SwiftUI

struct StudySessionView: View {
    let deckID: UUID

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: AppStore

    @State private var currentIndex: Int = 0
    @State private var isFlipped: Bool = false
    @State private var correctCount: Int = 0
    @State private var sessionDone: Bool = false
    @State private var showHint: Bool = false
    @State private var showingAddCard = false
    @State private var selectedCard: Flashcard? = nil

    private var deck: Deck? {
        store.decks.first(where: { $0.id == deckID })
    }

    private var cards: [Flashcard] {
        deck?.cards ?? []
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            if deck == nil {
                Text("Deck not found")
            } else if cards.isEmpty {
                VStack(spacing: 16) {
                    Spacer()

                    Text("📭")
                        .font(.system(size: 60))

                    Text("No cards in this deck")
                        .font(.title2)
                        .foregroundColor(AppTheme.textDark)

                    Text("Add cards to start studying")
                        .foregroundColor(AppTheme.textGray)

                    Spacer()

                    Button("Add Card") {
                        showingAddCard = true
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.accent)
                    .foregroundColor(.white)
                    .cornerRadius(AppTheme.cornerMedium)
                    .padding(.horizontal)

                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.textGray)
                }
            } else if sessionDone {
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

                    List(cards) { card in
                        HStack {
                            Text(card.front)
                            Spacer()
                            if card.learningState == .mastered {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }

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
                VStack(spacing: 24) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(AppTheme.textGray)
                                .font(.title3)
                        }

                        Spacer()

                        Button(action: {
                            showingAddCard = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(AppTheme.accent)
                        }

                        Text("Card \(currentIndex + 1) of \(cards.count)")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textGray)
                    }
                    .padding(.horizontal)

                    ProgressView(value: Double(currentIndex), total: Double(cards.count))
                        .tint(AppTheme.accent)
                        .padding(.horizontal)

                    Spacer()

                    FlashCardView(card: cards[currentIndex], isFlipped: $isFlipped)

                    if !isFlipped && !cards[currentIndex].hint.isEmpty {
                        Button(action: {
                            showHint.toggle()
                        }) {
                            Text(showHint ? "Hide Hint" : "Show Hint")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.accent)
                        }
                    }

                    if showHint && !cards[currentIndex].hint.isEmpty {
                        Text("💡 \(cards[currentIndex].hint)")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textGray)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        selectedCard = cards[currentIndex]
                    } label: {
                        Text("Edit Card")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.accent)
                    }

                    Button(role: .destructive) {
                        deleteCurrentCard()
                    } label: {
                        Text("Delete Card")
                            .font(.subheadline)
                    }

                    Spacer()

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
        .sheet(isPresented: $showingAddCard) {
            AddCardSheet(deckID: deckID)
                .environmentObject(store)
        }
        .sheet(item: $selectedCard) { card in
            AddCardSheet(deckID: deckID, cardToEdit: card)
                .environmentObject(store)
        }
        .onChange(of: isFlipped) { newValue in
            if newValue {
                showHint = false
            }
        }
        .onChange(of: cards.count) { _ in
            if cards.isEmpty {
                currentIndex = 0
            } else if currentIndex >= cards.count {
                currentIndex = cards.count - 1
            }
        }
    }

    private func advance(knew: Bool) {
        guard !cards.isEmpty else { return }
        let state: LearningState = knew ? .mastered : .learning
        store.setLearningState(deckID: deckID, cardID: cards[currentIndex].id, state: state)

        if knew {
            correctCount += 1
        }

        if currentIndex + 1 >= cards.count {
            sessionDone = true
        } else {
            currentIndex += 1
            isFlipped = false
            showHint = false
        }
    }

    private func deleteCurrentCard() {
        guard !cards.isEmpty else { return }
        let cardID = cards[currentIndex].id
        store.deleteCard(deckID: deckID, cardID: cardID)

        if currentIndex >= max(cards.count - 1, 0) {
            currentIndex = max(0, currentIndex - 1)
        }
    }
}
