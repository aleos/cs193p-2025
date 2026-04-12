//
//  ElapsedTimeTracker.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 12/4/2026.
//

import SwiftUI

extension View {
    func trackElapsedTime(in game: CodeBreaker) -> some View {
        modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    // MARK: Data In
    @Environment(\.scenePhase) private var scenePhase
    let game: CodeBreaker
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                game.startTimer()
            }
            .onDisappear {
                game.pauseTimer()
            }
            .onChange(of: game) { oldGame, newGame in
                oldGame.pauseTimer()
                newGame.startTimer()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .background:
                    game.pauseTimer()
                case .active:
                    game.startTimer()
                default:
                    break
                }
            }
    }
}
