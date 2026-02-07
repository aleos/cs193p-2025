//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 31/1/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker()
    
    enum Flavor: String, CaseIterable, Identifiable {
        case chocolate, vanilla, strawberry
        var id: Self { self }
    }

    @State private var selectedNumberOfPegs = 4

    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            Picker("Number of pegs", selection: $selectedNumberOfPegs) {
                ForEach(3...6, id: \.self) {
                    Text("^[\($0) pegs](inflect: true)")
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedNumberOfPegs, restart)
            Button("Restart") {
                selectedNumberOfPegs = (3...6).randomElement() ?? 4
            }
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
        .disabled(!game.canAttemptGuess)
    }
    
    func restart() {
        withAnimation {
            game = CodeBreaker(numberOfPegs: selectedNumberOfPegs)
        }
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                let pegColor = Color(name: code.pegs[index])
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(pegColor ?? .clear)
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.gray)
                        }
                    }
                    .overlay {
                        if pegColor == nil {
                            Text(code.pegs[index])
                                .font(.system(size: 120))
                                .minimumScaleFactor(9/120)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
}

#Preview {
    CodeBreakerView()
}
