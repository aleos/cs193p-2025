//
//  GameList.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 11/4/2026.
//

import SwiftData
import SwiftUI

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) private var modelContext
    @Environment(\.words) private var words
    @Environment(\.settings) private var settings
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeWordBreaker?
    @Query private var games: [CodeWordBreaker]
    
    enum FilterOption: CaseIterable {
        case all, completedOnly, incompleteOnly
        
        var title: String {
            switch self {
            case .all: "All"
            case .completedOnly: "Completed"
            case .incompleteOnly: "Incomplete"
            }
        }
    }
    
    init(selection: Binding<CodeWordBreaker?>, codeContains search: String = "", filterBy filter: FilterOption = .all) {
        _selection = selection
        
        let lowercasedSearch = search.lowercased().filter(\.isLetter)
        
        let searchPredicate: Predicate<CodeWordBreaker>
        if search.isEmpty {
            searchPredicate = #Predicate { _ in true }
        } else {
            searchPredicate = #Predicate { game in
                game.masterCode.word.contains(lowercasedSearch)
                || game._attempts.contains(where: { $0.word.contains(lowercasedSearch) })
            }
        }
        
        let filterPredicate: Predicate<CodeWordBreaker>
        switch filter {
        case .all:
            filterPredicate = .true
        case .completedOnly:
            filterPredicate = #Predicate { $0.isOver }
        case .incompleteOnly:
            filterPredicate = #Predicate { !$0.isOver }
        }
        
        let combinedPredicate = #Predicate<CodeWordBreaker> { game in
            searchPredicate.evaluate(game) && filterPredicate.evaluate(game)
        }
        _games = Query(
            filter: combinedPredicate,
            sort: [
                .init(\.lastAttemptedAt, order: .reverse),
                .init(\.created, order: .reverse)
            ]
        )
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                        .allowsHitTesting(false)
                }
                .contextMenu {
                    deleteButton(for: game)
                }
            }
            .onDelete { offsets in
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
        }
        .listStyle(.plain)
        .onChange(of: words.count) { oldValue, newValue in
            guard oldValue == 0, newValue > 0 else { return }
            initializeMasterCodes()
        }
        .onAppear(perform: addSampleGames)
        .onAppear {
            guard words.count > 0 else { return }
            initializeMasterCodes()
        }
        .toolbar {
            if words.count == 0 {
                ProgressView()
            } else {
                newGame
            }
            EditButton()
        }
    }
    
    private var newGame: some View {
        Menu("New game", systemImage: "plus") {
            ForEach(3...6, id: \.self) { numberOfLetters in
                Button("^[\(numberOfLetters) letters](inflect: true)") {
                    settings.defaultWordLength = numberOfLetters
                    createNewGame()
                }
            }
        } primaryAction: {
            createNewGame()
        }
    }
    
    private func createNewGame() {
        let game = CodeWordBreaker()
        initializeMasterCode(for: game)
        withAnimation {
            modelContext.insert(game)
        }
        selection = game
    }
    
    private func deleteButton(for game: CodeWordBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    private func initializeMasterCodes() {
        games.forEach(initializeMasterCode)
    }
    
    private func initializeMasterCode(for game: CodeWordBreaker) {
        guard game.masterCode.hasMissingPegs else { return } // The master code has already been set
        guard let word = words.random(length: settings.defaultWordLength) else {
            assertionFailure("Can't set master code: no words")
            return
        }
        game.restart(masterWord: word)
    }
    
    private func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeWordBreaker>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            [CodeWordBreaker].samples.forEach { modelContext.insert($0) }
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeWordBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
