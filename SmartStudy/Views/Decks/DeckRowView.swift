import SwiftUI

struct DeckRowView: View {
    let deck: Deck

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppTheme.tagColors[abs(deck.name.hashValue) % AppTheme.tagColors.count])
                    .frame(width: 52, height: 52)
                Text(deck.emoji)
                    .font(.system(size: 26))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(deck.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.textDark)
                Text("\(deck.cards.count) cards")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textGray)
            }

            Spacer()

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

struct DeckRowView_Previews: PreviewProvider {
    static var previews: some View {
        DeckRowView(deck: Deck(name: "Biology", emoji: "🧬"))
            .padding()
    }
}
