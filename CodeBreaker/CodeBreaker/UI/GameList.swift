//
//  GameList.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 1/4/2026.
//

import SwiftUI

struct GameList: View {
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    @State private var showGameEditor = false
    @State private var gameToEdit: CodeBreaker?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    deleteButton(for: game)
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
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton()
        }
        .onAppear(perform: addSampleGames)
    }
    
    private var addButton: some View {
        Button("Add game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue])
        }
        .onChange(of: gameToEdit) {
            showGameEditor = gameToEdit != nil
        }
        .sheet(isPresented: $showGameEditor, onDismiss: { gameToEdit = nil }) {
            gameEditor
        }
    }
    
    @ViewBuilder
    private var gameEditor: some View {
        if let gameToEdit {
            GameEditor(game: gameToEdit) {
                games.insert(gameToEdit, at: 0)
            }
        }
    }
    
    private func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 == game }
            }
        }
    }
    
    private func addSampleGames() {
        guard games.isEmpty else { return }
        games.append(.init(name: "Mastermind"))
        games.append(.init(name: "Faces"))
        games.append(.init(name: "Vehicles"))
        games.append(.init(name: "Animals"))
        games.append(.init(name: "Food"))
        games.append(.init(name: "Sports"))
        selection = games.randomElement()
    }
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
