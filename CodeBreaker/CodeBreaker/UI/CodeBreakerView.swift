//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 31/1/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game = CodeBreaker()
    @State private var selection = 0
    @State private var selectedNumberOfPegs = 4
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                CodeView(code: game.masterCode)
                ScrollView {
                    if !game.isOver || restarting {
                        CodeView(code: game.guess, selection: $selection) {
                            Button("Guess", action: guess)
                                .flexibleSystemFont()
                                .disabled(!game.canAttemptGuess)
                        }
                        .animation(nil, value: game.attempts.count)
                        .opacity(restarting ? 0 : 1)
                    }
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        CodeView(code: game.attempts[index]) {
                            let showMarkers = !hideMostRecentMarkers || index != game.attempts.indices.last
                            if showMarkers, let matches = game.attempts[index].matches {
                                MatchMarkers(matches: matches)
                            }
                        }
                        .transition(.attempt(game.isOver))
                    }
                }
                if !game.isOver {
                    PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                        .transition(.pegChooser)
                }
                Picker("Number of pegs", selection: $selectedNumberOfPegs) {
                    ForEach(3...6, id: \.self) {
                        Text("^[\($0) pegs](inflect: true)")
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedNumberOfPegs) {
                    game.restart(numberOfPegs: selectedNumberOfPegs)
                    selection = 0
                }
            }
            .padding()
            .toolbar {
                Button("Restart", systemImage: "arrow.circlepath") {
                    restart()
                }
            }
            .navigationTitle(game.selectedTheme)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.pegChoices.count
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
    
    func restart(numberOfPegs: Int? = nil) {
        withAnimation(.restart) {
            restarting = true
        } completion: {
            withAnimation(.restart) {
                game.restart(numberOfPegs: numberOfPegs ?? selectedNumberOfPegs)
                selection = 0
                restarting = false
            }
        }
    }
}

#Preview {
    CodeBreakerView()
}
