//
//  ElapsedTimeTracker.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 12/4/2026.
//

import SwiftUI

extension View {
    func trackElapsedTime(in game: CodeWordBreaker) -> some View {
        modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    // MARK: Data In
    @Environment(\.scenePhase) private var scenePhase
    let game: CodeWordBreaker

    func body(content: Content) -> some View {
        content
            .onAppear {
                game.resume()
            }
            .onDisappear {
                game.pause()
            }
            .onChange(of: game) { oldGame, newGame in
                oldGame.pause()
                newGame.resume()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .background:
                    game.pause()
                case .active:
                    game.resume()
                default:
                    break
                }
            }
    }
}
