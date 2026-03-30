//
//  GameSummary.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 30/3/2026.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeWordBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            if let lastAttempt = game.attempts.last {
                CodeView(code: lastAttempt)
            } else {
                CodeView(
                    code: Code(
                        kind: .attempt(Array(repeating: .nomatch, count: game.guess.pegs.count)),
                        numberOfPegs: game.guess.pegs.count
                    )
                )
            }
            Text("^[\(game.attempts.count) attempts](inflect: true)")
        }
    }
}

#Preview {
    @Previewable let game = CodeWordBreaker(word: "WORD")
    List {
        GameSummary(game: game)
    }
    List {
        GameSummary(game: game)
    }
    .listStyle(.plain)
}
