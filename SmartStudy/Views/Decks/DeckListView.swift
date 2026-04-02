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
                            .padding()
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteDeck)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .safeAreaInset(edge: .top) {
                HStack(spacing: 12) {
                    miniCard {
                        VStack {
                            Text("\(decks.count)")
                                .font(.title2)
                                .foregroundColor(.yellow)
                                .bold()
                            Text("decks")
                        }
                    }
                    miniCard {
                        VStack {
                            Text("\(decks.flatMap(\.cards).count)")
                                .font(.title2)
                                .foregroundColor(.green)
                                .bold()
                            Text("cards")
                        }
                    }
                    miniCard {
                        VStack {
                            Text("\(decks.flatMap{ $0.cards}.filter{ $0.learningState == .mastered }.count)")
                                .font(.title2)
                                .foregroundColor(.purple)
                                .bold()
                            Text("mastered")
                        }
                    }
                }
                .padding(.horizontal)
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
    
    func miniCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(AppTheme.cornerMedium)
    }
}

#Preview {
    DeckListView()
}
