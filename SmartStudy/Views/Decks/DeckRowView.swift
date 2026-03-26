//
//  DeckRowView.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import SwiftUI
import SwiftData

struct DeckRowView: View {
    let deck: Deck

    var body: some View {
        HStack(spacing: 16) {

            // Emoji icon with colored circle background
            ZStack {
                Circle()
                    .fill(AppTheme.tagColors[abs(deck.name.hashValue) % AppTheme.tagColors.count])
                    .frame(width: 52, height: 52)
                Text(deck.emoji)
                    .font(.system(size: 26))
            }

            // Deck name and card count
            VStack(alignment: .leading, spacing: 4) {
                Text(deck.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.textDark)
                Text("\(deck.cards.count) cards")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textGray)
            }

            Spacer()

            // Mastery percentage
            Text("\(Int(deck.masteryPercentage * 100))%")
                .font(.subheadline)
                .bold()
                .foregroundColor(AppTheme.accent)
        }
        .padding()
        .background(AppTheme.cardBG)
        .cornerRadius(AppTheme.cornerMedium)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// THIS IS JUST SO YOU CAN PREVIEW WHAT IT LOOKS LIKE WITHOUT ERROR
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Deck.self, configurations: config)
    let deck = Deck(name: "Biology", colorHex: "#B8D5C8", emoji: "🧬")
    container.mainContext.insert(deck)
    return DeckRowView(deck: deck)
        .modelContainer(container)
        .padding()
}
