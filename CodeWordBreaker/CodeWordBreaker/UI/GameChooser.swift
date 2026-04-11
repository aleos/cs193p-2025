//
//  GameChooser.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 30/3/2026.
//

import SwiftData
import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var isSettingsPresented: Bool = false
    @State private var selectedGame: CodeWordBreaker?
    
    var body: some View {
        NavigationSplitView {
            GameList(selection: $selectedGame)
                .sheet(isPresented: $isSettingsPresented) {
                    Settings(isPresented: $isSettingsPresented)
                }
                .toolbar {
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
    }
}

#Preview(traits: .swiftData) {
    GameChooser()
}
