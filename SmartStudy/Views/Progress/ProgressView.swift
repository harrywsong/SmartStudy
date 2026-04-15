//
//  ProgressView.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import SwiftUI
import SwiftData

struct ProgressHomeView: View {
    @Query var decks: [Deck]

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                if decks.isEmpty {
                    VStack(spacing: 12) {
                        Text("📊")
                            .font(.system(size: 60))
                        Text("No progress yet")
                            .font(.title2)
                            .foregroundColor(AppTheme.textDark)
                        Text("Study a deck to see your stats")
                            .foregroundColor(AppTheme.textGray)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("This Week's Activity")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.textDark)

                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(0..<7) { index in
                                        VStack {
                                            Rectangle()
                                                .fill(index == 3 ? AppTheme.accent : AppTheme.tagBeige)
                                                .frame(width: 30, height: CGFloat([40, 60, 30, 80, 50, 25, 65][index]))
                                                .cornerRadius(6)

                                            Text(["M","T","W","T","F","S","S"][index])
                                                .font(.caption2)
                                                .foregroundColor(AppTheme.textGray)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(AppTheme.cardBG)
                            .cornerRadius(AppTheme.cornerMedium)
                            .shadow(color: .black.opacity(0.05), radius: 4)
                            .padding(.horizontal)
                            
                            
                            //stats cards
                        HStack(spacing: 12) {

                          StatCard(icon: "flame.fill", value: "7", label: "Day Streak")

                                StatCard(icon: "bolt.fill", value: "75%", label: "Avg Accuracy")

                                StatCard(icon: "square.stack.3d.fill", value: "\(decks.reduce(0) { $0 + $1.masteredCount })", label: "Cards Mastered")
                            }
                            .padding(.horizontal)
                            
                            
                            ForEach(decks) { deck in
                                DeckProgressCard(deck: deck)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Progress")
        }
    }
}

struct DeckProgressCard: View {
    let deck: Deck

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Deck name row
            HStack {
                Text(deck.emoji + "  " + deck.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.textDark)
                Spacer()
                Text("\(Int(deck.masteryPercentage * 100))%")
                    .font(.headline)
                    .foregroundColor(AppTheme.accent)
            }

            // Progress bar
            ProgressView(value: deck.masteryPercentage)
                .tint(AppTheme.accent)

            // Card counts
            HStack {
                Text("\(deck.masteredCount) mastered")
                    .font(.caption)
                    .foregroundColor(AppTheme.textGray)
                Spacer()
                Text("\(deck.cards.count) total")
                    .font(.caption)
                    .foregroundColor(AppTheme.textGray)
            }
        }
        .padding()
        .background(AppTheme.cardBG)
        .cornerRadius(AppTheme.cornerMedium)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
    

struct StatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.accent)

            Text(value)
                .font(.headline)
                .foregroundColor(AppTheme.textDark)

            Text(label)
                .font(.caption)
                .foregroundColor(AppTheme.textGray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppTheme.cardBG)
        .cornerRadius(AppTheme.cornerMedium)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}
#Preview {
    ProgressHomeView()
}
