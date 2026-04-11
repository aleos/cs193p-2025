//
//  GameChooser.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 30/3/2026.
//

import SwiftData
import SwiftUI

struct GameChooser: View {
    // MARK: Data In
    @Environment(\.words) var words
    @Environment(\.settings) var settings
    
    // MARK: Data Owned by Me
    @State private var games: [CodeWordBreaker] = []
    @State private var isSettingsPresented: Bool = false
    @State private var selectedGame: CodeWordBreaker?
    
    var body: some View {
        NavigationSplitView {
            GameList(selection: $selectedGame)
                .sheet(isPresented: $isSettingsPresented) {
                    Settings(isPresented: $isSettingsPresented)
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        if words.count == 0 {
                            ProgressView()
                        } else {
                            newGame
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Settings", systemImage: "gearshape") {
                            isSettingsPresented = true
                        }
                    }
                }
                .navigationTitle("Code Word Breaker")
        } detail: {
            if let selectedGame {
                CodeWordBreakerView(game: selectedGame)
            } else {
                Text("Choose a game")
            }
        }
        .onChange(of: words.count) { oldValue, newValue in
            guard oldValue == 0, newValue > 0 else { return }
            initializeMasterCodes()
        }
        .onAppear {
            guard words.count > 0 else { return }
            initializeMasterCodes()
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
            games.insert(game, at: 0)
        }
        selectedGame = game
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
}

#Preview(traits: .swiftData) {
    GameChooser()
}
