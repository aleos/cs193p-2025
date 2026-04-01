//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 1/4/2026.
//

import SwiftUI

struct GameEditor: View {
    // MARK: Data (Function) In
    @Environment(\.dismiss) var dismiss
    
    // MARK: Data In
    var onChoose: (CodeBreaker) -> Void

    // MARK: Data Owned by Me
    @State private var draft: CodeBreaker
    @State private var showInvalidGameAlert = false

    init(game: CodeBreaker, onChoose: @escaping (CodeBreaker) -> Void) {
        self.onChoose = onChoose
        self._draft = State(initialValue: CodeBreaker(name: game.name, pegChoices: game.pegChoices))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $draft.name)
                        .autocapitalization(.words)
                        .autocorrectionDisabled(false)
                        .onSubmit {
                            done()
                        }
                }
                Section("Pegs") {
                    PegChoicesChooser(pegChoices: $draft.pegChoices)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        done()
                    }
                    .alert("Invalid Game", isPresented: $showInvalidGameAlert) {
                        Button("OK") {
                            showInvalidGameAlert = false
                        }
                    } message: {
                        Text("A game must have a name and more than one unique peg.")
                    }
                }
            }
        }
    }
    
    private func done() {
        if draft.isValid {
            onChoose(draft)
            dismiss()
        } else {
            showInvalidGameAlert = true
        }
    }
}

extension CodeBreaker {
    var isValid: Bool {
        !name.isEmpty && Set(pegChoices).count >= 2
    }
}

#Preview {
    @Previewable let game = CodeBreaker(
        name: "Preview",
        pegChoices: [.orange, .purple]
    )
    GameEditor(game: game) { draft in
        print("game name changed to \(draft.name)")
        print("game pegs changed to \(draft.pegChoices)")
    }
}
