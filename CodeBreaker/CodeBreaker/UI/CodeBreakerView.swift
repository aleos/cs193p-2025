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
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                CodeView(code: game.masterCode)
                ScrollView {
                    if !game.isOver {
                        CodeView(code: game.guess, selection: $selection) { guessButton }
                    }
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        CodeView(code: game.attempts[index]) {
                            if let matches = game.attempts[index].matches {
                                MatchMarkers(matches: matches)
                            }
                        }
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
                    restart(numberOfPegs: selectedNumberOfPegs)
                }
            }
            .padding()
            .toolbar {
                Button("Restart") {
                    withAnimation(.restart) {
                        game.restart()
                        selection = 0
                    }
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
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation(.guess) {
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
        .disabled(!game.canAttemptGuess)
    }
    
    func restart(numberOfPegs: Int? = nil) {
        game.restart(numberOfPegs: numberOfPegs ?? selectedNumberOfPegs)
    }
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
}

extension Animation {
    static let codeBreaker = Animation.easeInOut(duration: 3)
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(y: 200)
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        .init(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}
