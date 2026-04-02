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
    @State private var showHint: Bool = false
    @State private var showingAddCard = false
    
    var cards: [Flashcard] { deck.cards }
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            //  EMPTY DECK STATE
            if cards.isEmpty {
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
                
                //  SESSION COMPLETE
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
                
                //  STUDY MODE
            } else {
                VStack(spacing: 24) {
                    
                    // Header
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
                    
                    // Progress bar
                    ProgressView(value: Double(currentIndex), total: Double(cards.count))
                        .tint(AppTheme.accent)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // Flashcard
                    FlashCardView(card: cards[currentIndex], isFlipped: $isFlipped)
                    
                    // Hint Button
                    if !isFlipped && !cards[currentIndex].hint.isEmpty {
                        Button(action: {
                            showHint.toggle()
                        }) {
                            Text(showHint ? "Hide Hint" : "Show Hint")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.accent)
                        }
                    }
                    
                    // Hint Text
                    if showHint && !cards[currentIndex].hint.isEmpty {
                        Text("💡 \(cards[currentIndex].hint)")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textGray)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Delete Card Button
                    Button(role: .destructive) {
                        deleteCurrentCard()
                    } label: {
                        Text("Delete Card")
                            .font(.subheadline)
                    }
                    
                    
                    
                    Spacer()
                    
                    // Answer buttons
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
        
        // Add Card Sheet
        .sheet(isPresented: $showingAddCard) {
            AddCardSheet(deck: deck)
        }
        
        // Auto-hide hint when flipped
        .onChange(of: isFlipped) { _, newValue in
            if newValue {
                showHint = false
            }
        }
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
            showHint = false
        }
    }
    
    func deleteCurrentCard() {
        guard !cards.isEmpty else { return }

        let card = cards[currentIndex]
        context.delete(card)

        try? context.save()

        if currentIndex >= cards.count - 1 {
            currentIndex = max(0, currentIndex - 1)
        }
    }
    
}
