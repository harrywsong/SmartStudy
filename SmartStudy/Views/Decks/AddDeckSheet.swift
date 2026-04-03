//
//  AddDeckSheet.swift
//  SmartStudy
//
//  Created by Amelework Murti on 2026-04-01.
//
import SwiftUI
import SwiftData

struct AddDeckSheet: View {
    @Environment(\.modelContext) private var context
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
                            deck.name = name
                            deck.emoji = emoji
                        } else {
                            let deck = Deck(name: name, emoji: emoji)
                            context.insert(deck)
                        }
                        try? context.save()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
