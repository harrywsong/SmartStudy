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

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var front = ""
    @State private var back = ""
    @State private var hint = ""

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
            .navigationTitle("New Card")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let card = Flashcard(
                            front: front,
                            back: back,
                            hint: hint
                        )

                        deck.cards.append(card)
                        context.insert(card)

                        try? context.save()
                        dismiss()
                    }
                    .disabled(front.isEmpty || back.isEmpty)
                }
            }
        }
    }
}
