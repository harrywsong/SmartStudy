//
//  Assignment.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import Foundation
import SwiftData

enum Priority: String, Codable, CaseIterable {
    case low    = "Low"
    case medium = "Medium"
    case high   = "High"
}

@Model
class Assignment {
    var title: String
    var subject: String
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
    var createdAt: Date

    init(title: String, subject: String, dueDate: Date, priority: Priority = .medium) {
        self.title = title
        self.subject = subject
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = false
        self.createdAt = Date()
    }
}
