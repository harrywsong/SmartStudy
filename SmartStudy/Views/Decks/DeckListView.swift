//
//  DeckListView.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import SwiftUI
import SwiftData

struct DeckListView: View {
    @State private var showingAddDeck = false
    @Environment(\.modelContext) private var context
    @Query var decks: [Deck]

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                if decks.isEmpty {
                    // Empty state
                    VStack(spacing: 12) {
                        Text("📚")
                            .font(.system(size: 60))

                        Text("No decks yet")
                            .font(.title2)
                            .foregroundColor(AppTheme.textDark)

                        Text("Tap + to create your first deck")
                            .foregroundColor(AppTheme.textGray)
                    }

                } else {
                    // Use List ONLY (no ScrollView)
                    List {
                        ForEach(decks) { deck in
                            NavigationLink(destination: StudySessionView(deck: deck)) {
                                DeckRowView(deck: deck)
                            }
                        }
                        .onDelete(perform: deleteDeck)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Decks")

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddDeck = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(AppTheme.accent)
                    }
                }
            }

            .sheet(isPresented: $showingAddDeck) {
                AddDeckSheet()
            }
        }
    }

    
    func deleteDeck(at offsets: IndexSet) {
        for index in offsets {
            let deck = decks[index]
            context.delete(deck)
        }

        try? context.save()
    }
}

#Preview {
    DeckListView()
}
