//
//  AddCardSheet.swift
//  SmartStudy
//
//  Created by Amelework Murti on 2026-04-02.
//
import SwiftUI
import SwiftData

struct AddCardSheet: View {
    let deck: Deck
    let cardToEdit: Flashcard?

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var front = ""
    @State private var back = ""
    @State private var hint = ""
    
    init(deck: Deck, cardToEdit: Flashcard? = nil) {
        self.deck = deck
        self.cardToEdit = cardToEdit
    }

    var body: some View {
        NavigationStack {
            Form {

                Section("Front (Question)") {
                    TextField("Enter question", text: $front)
                }

                Section("Back (Answer)") {
                    TextField("Enter answer", text: $back)
                }

                Section("Hint (Optional)") {
                    TextField("Enter hint", text: $hint)
                }
            }
            .onAppear {
                if let card = cardToEdit {
                    front = card.front
                    back = card.back
                    hint = card.hint
                }
            }
            .navigationTitle(cardToEdit == nil ? "New Card" : "Edit Card")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let card = cardToEdit {
                            card.front = front
                            card.back = back
                            card.hint = hint
                            
                        } else {
                            let card = Flashcard(
                                front: front,
                                back: back,
                                hint: hint
                            )
                            
                            deck.cards.append(card)
                            context.insert(card)
                        }
                        try? context.save()
                        dismiss()
                    }
                    .disabled(front.isEmpty || back.isEmpty)
                }
            }
        }
    }
}
