//
//  Flashcard.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import Foundation
import SwiftData

enum LearningState: String, Codable {
    case new
    case learning
    case mastered
}

@Model
class Flashcard {
    var front: String
    var back: String
    var hint: String
    var learningState: LearningState
    var createdAt: Date

    init(front: String, back: String, hint: String = "") {
        self.front = front
        self.back = back
        self.hint = hint
        self.learningState = .new
        self.createdAt = Date()
    }
}
