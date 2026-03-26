//
//  FlashCardView.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import SwiftUI
import SwiftData

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

// THIS IS JUST SO YOU CAN PREVIEW WHAT IT LOOKS LIKE WITHOUT ERROR
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Flashcard.self, configurations: config)
    let card = Flashcard(front: "What is photosynthesis?", back: "Converting sunlight into energy.", hint: "Think about plants.")
    container.mainContext.insert(card)
    return FlashCardViewPreviewWrapper(card: card)
        .modelContainer(container)
}

private struct FlashCardViewPreviewWrapper: View {
    let card: Flashcard
    @State private var isFlipped = false
    var body: some View {
        FlashCardView(card: card, isFlipped: $isFlipped)
    }
}
