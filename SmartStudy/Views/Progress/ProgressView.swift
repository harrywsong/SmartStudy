import SwiftUI

struct ProgressHomeView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                if store.decks.isEmpty {
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
                            ForEach(store.decks) { deck in
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
            HStack {
                Text(deck.emoji + "  " + deck.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.textDark)
                Spacer()
                Text("\(Int(deck.masteryPercentage * 100))%")
                    .font(.headline)
                    .foregroundColor(AppTheme.accent)
            }

            ProgressView(value: deck.masteryPercentage)
                .tint(AppTheme.accent)

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

struct ProgressHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressHomeView()
            .environmentObject(AppStore())
    }
}
