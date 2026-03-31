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
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    NavigationLink(value: game.masterCode.pegs) {
                        Text("Cheat")
                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeBreakerView(game: game)
            }
            .navigationDestination(for: [Peg].self) { pegs in
                PegChooser(choices: pegs)
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
        } detail: {
            Text("Choose a game")
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            games.append(.init(name: "Mastermind"))
            games.append(.init(name: "Faces"))
            games.append(.init(name: "Vehicles"))
            games.append(.init(name: "Animals"))
            games.append(.init(name: "Food"))
            games.append(.init(name: "Sports"))
        }
    }
}

#Preview {
    GameChooser()
}
