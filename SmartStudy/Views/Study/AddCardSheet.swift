import SwiftUI

struct AddCardSheet: View {
    let deckID: UUID
    let cardToEdit: Flashcard?

    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var front = ""
    @State private var back = ""
    @State private var hint = ""

    init(deckID: UUID, cardToEdit: Flashcard? = nil) {
        self.deckID = deckID
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
                            store.updateCard(deckID: deckID, cardID: card.id, front: front, back: back, hint: hint)
                        } else {
                            store.addCard(deckID: deckID, front: front, back: back, hint: hint)
                        }
                        dismiss()
                    }
                    .disabled(front.isEmpty || back.isEmpty)
                }
            }
        }
    }
}
