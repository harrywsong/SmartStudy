import SwiftUI

struct DeckListView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showingAddDeck = false
    @State private var selectedDeck: Deck?

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                if store.decks.isEmpty {
                    VStack(spacing: 12) {
                        Text("📚")
                            .font(.system(size: 60))

                        Text("No decks yet")
                            .font(.title2)
                            .foregroundColor(AppTheme.textDark)

                        Text("Tap + to create your first deck")
                            .foregroundColor(AppTheme.textGray)
                    }
                } else {
                    List {
                        ForEach(store.decks) { deck in
                            NavigationLink(destination: StudySessionView(deckID: deck.id)) {
                                DeckRowView(deck: deck)
                                    .onLongPressGesture {
                                        selectedDeck = deck
                                    }
                            }
                            .padding()
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteDeck)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .safeAreaInset(edge: .top) {
                HStack(spacing: 12) {
                    miniCard {
                        VStack {
                            Text("\(store.decks.count)")
                                .font(.title2)
                                .foregroundColor(.yellow)
                                .bold()
                            Text("decks")
                        }
                    }
                    miniCard {
                        VStack {
                            Text("\(store.decks.flatMap(\.cards).count)")
                                .font(.title2)
                                .foregroundColor(.green)
                                .bold()
                            Text("cards")
                        }
                    }
                    miniCard {
                        VStack {
                            Text("\(store.decks.flatMap { $0.cards }.filter { $0.learningState == .mastered }.count)")
                                .font(.title2)
                                .foregroundColor(.purple)
                                .bold()
                            Text("mastered")
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("My Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddDeck = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(AppTheme.accent)
                    }
                }
            }
            .sheet(isPresented: $showingAddDeck) {
                AddDeckSheet()
                    .environmentObject(store)
            }
            .sheet(item: $selectedDeck) { deck in
                AddDeckSheet(deckToEdit: deck)
                    .environmentObject(store)
            }
        }
    }

    private func deleteDeck(at offsets: IndexSet) {
        store.deleteDecks(at: offsets)
    }

    private func miniCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(AppTheme.cornerMedium)
    }
}

struct DeckListView_Previews: PreviewProvider {
    static var previews: some View {
        DeckListView()
            .environmentObject(AppStore())
    }
}
