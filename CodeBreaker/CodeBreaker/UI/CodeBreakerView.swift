//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 31/1/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Shared with Me
    @Binding var game: CodeBreaker
    
    // MARK: Data Owned by Me
    @State private var selection = 0
    @State private var selectedNumberOfPegs = 4
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                CodeView(code: game.masterCode) {
                    ElapsedTime(startTime: game.startTime, endTime: game.endTime)
                        .flexibleSystemFont()
                        .monospaced()
                        .lineLimit(1)
                }
                ScrollView {
                    if !game.isOver {
                        CodeView(code: game.guess, selection: $selection) {
                            Button("Guess", action: guess)
                                .flexibleSystemFont()
                                .disabled(!game.canAttemptGuess)
                        }
                        .animation(nil, value: game.attempts.count)
                        .opacity(restarting ? 0 : 1)
                    }
                    ForEach(game.attempts, id: \.pegs) { attempt in
                        CodeView(code: attempt) {
                            let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                            if showMarkers, let matches = attempt.matches {
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
    
    func restart(numberOfPegs: Int? = nil) {
        withAnimation(.restart) {
            restarting = game.isOver
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
    @Previewable @State var game = CodeBreaker()
    CodeBreakerView(game: $game)
}
