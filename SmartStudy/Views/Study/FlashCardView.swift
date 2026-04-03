import SwiftUI

struct FlashCardView: View {
    let card: Flashcard
    @Binding var isFlipped: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text(isFlipped ? "ANSWER" : "QUESTION")
                .font(.caption)
                .fontWeight(.semibold)
                .tracking(1.5)
                .foregroundColor(AppTheme.textGray)

            Spacer()

            Text(isFlipped ? card.back : card.front)
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTheme.textDark)

            Spacer()

            if !isFlipped {
                Text("Tap to reveal answer")
                    .font(.caption)
                    .foregroundColor(AppTheme.textGray)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .background(isFlipped ? AppTheme.tagBeige : AppTheme.cardBG)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
        .onTapGesture {
            isFlipped.toggle()
        }
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView(card: Flashcard(front: "Question", back: "Answer"), isFlipped: .constant(false))
    }
}
