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
    @Environment(\.words) var words
    @Environment(\.settings) var settings
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeWordBreaker?
    @Query private var games: [CodeWordBreaker]
    
    // MARK: Data Owned by Me
    @State private var gameToEdit: CodeWordBreaker?
    
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
