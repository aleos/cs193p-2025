//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 30/3/2026.
//

import SwiftUI

struct GameChooser: View {
    // Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        List(games, id: \.pegChoices) { game in
            GameSummary(game: game)
        }
        .listStyle(.plain)
        .onAppear {
            games.append(.init(name: "Mastermind"))
            games.append(.init(name: "Faces"))
            games.append(.init(name: "Vehicles"))
            games.append(.init(name: "Animals"))
            games.append(.init(name: "Food"))
            games.append(.init(name: "Sports"))
        }
    }
}

#Preview {
    GameChooser()
}
