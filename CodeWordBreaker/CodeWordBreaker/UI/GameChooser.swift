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
    @State private var games: [CodeWordBreaker] = [.init(), .init(), .init()]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    NavigationLink(value: game.masterCode.word) {
                        Text("Cheat")
                    }
                }
            }
            .navigationDestination(for: CodeWordBreaker.self) { game in
                CodeWordBreakerView(game: game)
            }
            .navigationDestination(for: String.self) { word in
                Text(word).font(.largeTitle)
            }
            .toolbar {
                if words.count == 0 {
                    ProgressView()
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
}

#Preview {
    GameChooser()
}
