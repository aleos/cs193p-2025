//
//  GameChooser.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 30/3/2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var games: [CodeWordBreaker] = .samples
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                            .allowsHitTesting(false)
                    }
                    .swipeActions(edge: .leading) {
                        NavigationLink(value: game.masterCode.word) {
                            Label("Cheat", systemImage: "eye")
                                .tint(.purple)
                        }
                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
            }
            .listStyle(.plain)
            .onAppear(perform: sortGames)
            .navigationDestination(for: CodeWordBreaker.self) { game in
                CodeWordBreakerView(game: game)
            }
            .navigationDestination(for: String.self) { word in
                Text(word).font(.largeTitle)
            }
            .toolbar {
                if words.count == 0 {
                    ProgressView()
                } else {
                    newGame
                }
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
        Button("New game", systemImage: "plus") {
            let game = CodeWordBreaker()
            initializeMasterCode(for: game)
            withAnimation {
                games.insert(game, at: 0)
                sortGames()
            }
            path.append(game)
        }
    }
    
    private func initializeMasterCodes() {
        games.forEach(initializeMasterCode)
    }
    
    private func initializeMasterCode(for game: CodeWordBreaker) {
        guard game.masterCode.hasMissingPegs else { return } // The master code has already been set
        guard let word = words.random(length: game.masterCode.pegs.count) else {
            assertionFailure("Can't set master code: no words")
            return
        }
        game.masterCode.word = word
    }
    
    private func sortGames() {
        games.sort(using: KeyPathComparator(\.lastAttemptedAt, order: .reverse))
    }
}

#Preview {
    GameChooser()
}
