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
            Text(game.selectedTheme).font(.title)
            Text(game.masterCode.word)
                .frame(maxHeight: 50)
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
