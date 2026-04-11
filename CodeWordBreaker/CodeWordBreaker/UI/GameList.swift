//
//  GameList.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 11/4/2026.
//

import SwiftData
import SwiftUI

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) private var modelContext
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeWordBreaker?
    @Query private var games: [CodeWordBreaker]
    
    // MARK: Data Owned by Me
    @State private var gameToEdit: CodeWordBreaker?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                        .allowsHitTesting(false)
                }
                .swipeActions(edge: .leading) {
                    NavigationLink(value: game.masterCode.word) {
                        Label("Cheat", systemImage: "eye")
                            .tint(.purple)
                    }
                }
            }
            .onDelete { offsets in
                offsets
                    .map { games[$0] }
                    .forEach { modelContext.delete($0) }
            }
        }
        .listStyle(.plain)
        .onAppear(perform: addSampleGames)
        .navigationDestination(for: String.self) { word in
            Text(word).font(.largeTitle)
        }
    }
    
    private func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeWordBreaker>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            [CodeWordBreaker].samples.forEach { modelContext.insert($0) }
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeWordBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
