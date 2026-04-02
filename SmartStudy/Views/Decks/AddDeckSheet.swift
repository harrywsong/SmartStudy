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

    var body: some View {
        NavigationStack {
            Form {
                Section("Deck Info") {
                    TextField("Deck name", text: $name)
                    TextField("Emoji (optional)", text: $emoji)
                }
            }
            .navigationTitle("New Deck")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let deck = Deck(name: name, emoji: emoji)
                        context.insert(deck)
                        try? context.save()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
