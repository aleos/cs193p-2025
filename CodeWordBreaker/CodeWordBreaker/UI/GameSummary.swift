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
            Group {
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
            }
            .frame(maxHeight: 50)
            HStack {
                Text("^[\(game.attempts.count) attempts](inflect: true)")
                Spacer()
                time
            }
        }
    }
    
    private var time: some View {
        let startTime: Date
        var endTime: Date?
        if let lastAppearedAt = game.lastAppearedAt {
            startTime = lastAppearedAt.addingTimeInterval(-game.accumulatedTime)
            endTime = game.endTime
        } else {
            startTime = .now.addingTimeInterval(-game.accumulatedTime)
            endTime = .now
        }
        return ElapsedTime(startTime: startTime, endTime: endTime)
            .monospaced()
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
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
