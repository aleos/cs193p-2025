//
//  ElapsedTimeTracker.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 12/4/2026.
//

import SwiftData
import SwiftUI

extension View {
    func trackElapsedTime(in game: CodeBreaker) -> some View {
        modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    // MARK: Data In
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    let game: CodeBreaker
    
    // MARK: Data Owned by Me
    var modelContextWillSavePublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: ModelContext.willSave, object: modelContext)
    }
    
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
            .onReceive(modelContextWillSavePublisher) {_ in 
                game.updateElapsedTime()
                print("updated elapsed time to \(game.elapsedTime)")
            }
    }
}
