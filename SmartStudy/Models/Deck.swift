//
//  Deck.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Deck {
    var name: String
    var colorHex: String
    var emoji: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade)
    var cards: [Flashcard] = []

    init(name: String, colorHex: String = "#B7D5C8", emoji: String = "📚") {
        self.name = name
        self.colorHex = colorHex
        self.emoji = emoji
        self.createdAt = Date()
    }

    var masteredCount: Int {
        cards.filter { $0.learningState == .mastered }.count
    }

    var masteryPercentage: Double {
        guard !cards.isEmpty else { return 0 }
        return Double(masteredCount) / Double(cards.count)
    }
}
