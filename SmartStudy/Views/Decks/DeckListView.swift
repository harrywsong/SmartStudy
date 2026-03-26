//
//  DeckListView.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import SwiftUI
import SwiftData

struct DeckListView: View {

    // This pulls all Deck objects from SwiftData
    @Query var decks: [Deck]

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                if decks.isEmpty {
                    // Shown when there are no decks yet
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
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(decks) { deck in
                                DeckRowView(deck: deck)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Decks")
        }
    }
}

#Preview {
    DeckListView()
}
