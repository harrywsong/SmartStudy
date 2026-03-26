//
//  SmartStudyApp.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import SwiftUI
import SwiftData

@main
struct SmartStudyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Deck.self, Flashcard.self, Assignment.self])
    }
}
