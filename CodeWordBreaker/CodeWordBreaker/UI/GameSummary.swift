//
//  GameSummary.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 30/3/2026.
//

import SwiftUI

struct GameSummary: View {
    // MARK: Data In
    let game: CodeWordBreaker
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if let lastAttempt = game.attempts.first {
                    CodeView(code: lastAttempt)
                } else {
                    CodeView(
                        code: Code(
                            kind: .attempt(Array(repeating: .nomatch, count: game.guess.pegs.count)),
                            numberOfPegs: game.guess.pegs.count
                        )
                    )
                }
            }
            .frame(maxHeight: 50)
            HStack {
                Text("^[\(game.attempts.count) attempts](inflect: true)")
                Spacer()
                ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                    .monospaced()
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable let game = CodeWordBreaker(word: "WORD")
    List {
        GameSummary(game: game)
    }
    List {
        GameSummary(game: game)
    }
    .listStyle(.plain)
}
