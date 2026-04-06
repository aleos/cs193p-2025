//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 30/3/2026.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempts](inflect: true)")
        }
    }
}

#Preview(traits: .swiftData) {
    List {
        GameSummary(game: .init(name: "Mastermind"))
    }
    List {
        GameSummary(game: .init(name: "Mastermind"))
    }
    .listStyle(.plain)
}
