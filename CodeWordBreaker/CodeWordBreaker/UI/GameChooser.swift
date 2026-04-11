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
    @State private var search: String = ""
    @State private var filterOption: GameList.FilterOption = .all
    
    var body: some View {
        NavigationSplitView {
            Picker("Show", selection: $filterOption.animation(.default)) {
                ForEach(GameList.FilterOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            GameList(selection: $selectedGame, codeContains: search, filterBy: filterOption)
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
                .searchable(text: $search)
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
