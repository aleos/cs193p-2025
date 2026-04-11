//
//  CodeWordBreakerView.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftUI

struct CodeWordBreakerView: View {
    // MARK: Data Shared with Me
    let game: CodeWordBreaker
    
    // MARK: Data Owned by Me
    @State private var selection = 0
    @State private var invalidGuessCount = 0
    @State private var checker = UITextChecker()
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
                .padding(.horizontal)
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection)
                        .padding(.horizontal)
                        .transaction { $0.animation = nil }
                        .modifier(ShakeEffect(shakes: invalidGuessCount))
                }
                ForEach(game.attempts) { attempt in
                    CodeView(code: attempt)
                        .transition(.attempt(game.isOver))
                }
                .padding(.horizontal)
            }
            .scrollClipDisabled()
            if !game.isOver {
                PegKeyboard(onChoose: changePegAtSelection, onErase: removePegAtSelection, onGuess: guess, canGuess: game.canAttemptGuess, bestResult: game.bestResult)
                    .padding()
                    .background {
                        Rectangle()
                            .clipShape(.rect(cornerRadius: 16))
                            .foregroundStyle(.background)
                            .ignoresSafeArea(.all, edges: .bottom)
                    }
                    .transition(.pegChooser)
            }
        }
        .padding(.top)
        .toolbar {
            ToolbarItem {
                ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                    .monospaced()
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .trackElapsedTime(in: game)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.guess.pegs.count
    }
    
    func removePegAtSelection() {
        selection = max(0, selection - 1)
        game.setGuessPeg(.missing, at: selection)
    }
    
    func guess() {
        guard checker.isAWord(game.guess.word.lowercased()) else {
            withAnimation(.linear(duration: 0.4)) {
                invalidGuessCount += 1
            }
            return
        }
        withAnimation(.guess) {
            game.attemptGuess()
            selection = 0
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable let game: CodeWordBreaker = .sample
    NavigationStack {
        CodeWordBreakerView(game: game)
    }
}
