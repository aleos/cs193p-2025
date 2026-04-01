//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 1/4/2026.
//

import SwiftUI

struct GameEditor: View {
    @Bindable var game: CodeBreaker

    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $game.name)
            }
            Section("Pegs") {
                PegChoicesChooser(pegChoices: $game.pegChoices)
            }
        }
    }
}

#Preview {
    @Previewable let game = CodeBreaker(
        name: "Preview",
        pegChoices: [Color.orange.toHex(), Color.purple.toHex()]
    )
    GameEditor(game: game)
        .onChange(of: game.name) {
            print("game name changed to \(game.name)")
        }
        .onChange(of: game.pegChoices) {
            print("game pegs changed to \(game.pegChoices)")
        }
}
