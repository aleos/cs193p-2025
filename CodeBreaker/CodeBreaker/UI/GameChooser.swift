//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 30/3/2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var selection: CodeBreaker?
    
    @State private var sortOption: GameList.SortOption = .name
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Picker("Sort by", selection: $sortOption.animation(.default)) {
                ForEach(GameList.SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            GameList(sortBy: sortOption, selection: $selection)
                .navigationTitle("Code Breaker")
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview(traits: .swiftData) {
    GameChooser()
}
