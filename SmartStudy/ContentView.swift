//
//  ContentView.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {

            // Tab 1 - Decks
            DeckListView()
                .tabItem {
                    Label("Decks", systemImage: "rectangle.stack")
                }

            // Tab 2 - Progress
            ProgressHomeView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }

            // Tab 3 - Assignments
            AssignmentListView()
                .tabItem {
                    Label("Assignments", systemImage: "checklist")
                }

        }
        .tint(AppTheme.accent) // makes the selected tab use our gold color
    }
}

#Preview {
    ContentView()
}
