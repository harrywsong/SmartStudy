import SwiftUI

struct AddDeckSheet: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var emoji = "📚"

    let deckToEdit: Deck?

    init(deckToEdit: Deck? = nil) {
        self.deckToEdit = deckToEdit
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Deck Info") {
                    TextField("Deck name", text: $name)
                    TextField("Emoji (optional)", text: $emoji)
                }
            }
            .onAppear {
                if let deck = deckToEdit {
                    name = deck.name
                    emoji = deck.emoji
                }
            }
            .navigationTitle(deckToEdit == nil ? "New Deck" : "Edit Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let deck = deckToEdit {
                            store.updateDeck(id: deck.id, name: name, emoji: emoji)
                        } else {
                            store.addDeck(name: name, emoji: emoji)
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
