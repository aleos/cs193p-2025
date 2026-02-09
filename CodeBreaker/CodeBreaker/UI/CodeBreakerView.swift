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
                        CodeView(code: game.guess, selection: $selection) { guessButton }
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
                    restart(numberOfPegs: selectedNumberOfPegs)
                }
            }
            .padding()
            .toolbar {
                Button("Restart") {
                    withAnimation(.restart) {
                        restarting = true
                    } completion: {
                        withAnimation(.restart) {
                            game.restart()
                            selection = 0
                            restarting = false
                        }
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
                hideMostRecentMarkers = true
            } completion: {
                withAnimation(.guess) {
                    hideMostRecentMarkers = false
                }
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
    static func attempt(_ isOver: Bool) -> AnyTransition {
        AnyTransition.asymmetric(insertion: isOver ? .opacity : .move(edge: .top), removal: .move(edge: .trailing))
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        .init(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}
