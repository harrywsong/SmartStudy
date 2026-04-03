import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DeckListView()
                .tabItem {
                    Label("Decks", systemImage: "rectangle.stack")
                }

            ProgressHomeView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }

            AssignmentListView()
                .tabItem {
                    Label("Assignments", systemImage: "checklist")
                }
        }
        .accentColor(AppTheme.accent)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppStore())
    }
}
