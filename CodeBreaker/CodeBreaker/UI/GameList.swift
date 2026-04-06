//
//  GameList.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 1/4/2026.
//

import SwiftData
import SwiftUI

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    @Query private var games: [CodeBreaker]
    
    // MARK: Data Owned by Me
    @State private var gameToEdit: CodeBreaker?
    
    init(sortBy: SortOption = .name, nameContains search: String = "", selection: Binding<CodeBreaker?>) {
        _selection = selection
        let lowercasedSearch = search.lowercased()
        let capitalizedSearch = search.capitalized
        let predicate = #Predicate<CodeBreaker> { game in
            search.isEmpty || game.name.contains(lowercasedSearch) || game.name.contains(capitalizedSearch)
        }
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \.name)
        case .recent: _games = Query(filter: predicate, sort: \.lastAttemptDate, order: .reverse)
        }
    }
    
    enum SortOption: CaseIterable {
        case name, recent
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            }
        }
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    editButton(for: game) // editing a game
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) {
                    editButton(for: game).tint(.accentColor)
                }
            }
            .onDelete { offsets in
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton() // editing the List of games
        }
        .onAppear(perform: addSampleGames)
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    private var addButton: some View {
        Button("Add game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue])
        }
        .sheet(item: $gameToEdit, content: gameEditor)
    }
    
    @ViewBuilder
    private func gameEditor(game: CodeBreaker) -> some View {
        GameEditor(game: game) { editedGame in
            if games.contains(game) {
                modelContext.delete(game)
            }
            modelContext.insert(editedGame)
        }
    }
    
    private func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    private func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            modelContext.insert(CodeBreaker(name: "Mastermind"))
            modelContext.insert(CodeBreaker(name: "Earth Tones"))
            modelContext.insert(CodeBreaker(name: "Undersea"))
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
