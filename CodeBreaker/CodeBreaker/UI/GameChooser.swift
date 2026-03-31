//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 30/3/2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    @State private var selection: CodeBreaker?
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(selection: $selection) {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    .contextMenu {
                        Button("Delete", systemImage: "minus.circle", role: .destructive) {
                            withAnimation {
                                games.removeAll { $0 == game }
                            }
                        }
                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .onChange(of: games) {
                if let selection, !games.contains(selection) {
                    self.selection = nil
                }
            }
            .navigationTitle("Code Breaker")
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
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
        .onAppear {
            games.append(.init(name: "Mastermind"))
            games.append(.init(name: "Faces"))
            games.append(.init(name: "Vehicles"))
            games.append(.init(name: "Animals"))
            games.append(.init(name: "Food"))
            games.append(.init(name: "Sports"))
            selection = games.first
        }
    }
}

#Preview {
    GameChooser()
}
