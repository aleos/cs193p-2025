//
//  ElapsedTimeTracker.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 12/4/2026.
//

import SwiftData
import SwiftUI

extension View {
    func trackElapsedTime(in game: CodeWordBreaker) -> some View {
        modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    // MARK: Data In
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    let game: CodeWordBreaker
    
    // MARK: Data Owned by Me
    var modelContextWillSavePublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: ModelContext.willSave, object: modelContext)
    }
    
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
            .onReceive(modelContextWillSavePublisher) {_ in
                game.updateElapsedTime()
                print("updated elapsed time to \(game.elapsedTime)")
            }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var game = CodeWordBreaker.sample
    NavigationStack {
        Color.clear
            .trackElapsedTime(in: game)
            .toolbar {
                ToolbarItem {
                    ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                        .monospaced()
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
    }
}
