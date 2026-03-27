//
//  CodeWordBreakerView.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftUI

struct CodeWordBreakerView: View {
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var game = CodeWordBreaker()
    @State private var selection = 0
    @State private var selectedNumberOfPegs = 4
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                CodeView(code: game.masterCode)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                ScrollView {
                    if !game.isOver || restarting {
                        CodeView(code: game.guess, selection: $selection)
                            .opacity(restarting ? 0 : 1)
                    }
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        CodeView(code: game.attempts[index])
                            .transition(.attempt(game.isOver))
                    }
                }
                if !game.isOver {
                    Group {
                        PegKeyboard(onChoose: changePegAtSelection, bestResult: game.bestResult)
                        if game.masterCode.hasMissingPegs {
                            ProgressView()
                        } else {
                            Button("Guess", action: guess)
                                .buttonStyle(.glassProminent)
                                .disabled(!game.canAttemptGuess)
                        }
                    }
                    .transition(.pegChooser)
                }
            }
            .padding()
            .toolbar {
                Button("Restart", systemImage: "arrow.circlepath") {
                    restart()
                }
            }
            .navigationTitle(game.selectedTheme.capitalized)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Picker("Number of pegs", selection: $selectedNumberOfPegs) {
                        ForEach(3...6, id: \.self) {
                            Text("^[\($0) letters](inflect: true)")
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedNumberOfPegs) {
                        restart()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        // words are loaded asynchronously, so when they arrive,
        // set the master word without restarting the whole game
        .onChange(of: words.count) {
            guard game.masterCode.hasMissingPegs else { return }
            if let word = words.random(length: game.masterCode.pegs.count) {
                game.masterCode.word = word
            }
        }
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.guess.pegs.count
    }
    
    func guess() {
        withAnimation(.guess) {
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
    
    func restart() {
        withAnimation(.restart) {
            restarting = true
        } completion: {
            withAnimation(.restart) {
                game.restart(numberOfPegs: selectedNumberOfPegs, masterWord: words.random(length: selectedNumberOfPegs))
                selection = 0
                restarting = false
            }
        }
    }
}

#Preview {
    CodeWordBreakerView()
}
