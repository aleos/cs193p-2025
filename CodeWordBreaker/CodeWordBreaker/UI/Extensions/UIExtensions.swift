//
//  UIExtensions.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.bouncy
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
    static let selection = Animation.codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(y: 300)
    static func attempt(_ isOver: Bool) -> AnyTransition {
        AnyTransition.asymmetric(insertion: isOver ? .opacity : .move(edge: .top), removal: .move(edge: .trailing))
    }
}

extension View {
    func flexibleSystemFont(minimum: CGFloat = 8, maximum: CGFloat = 80) -> some View {
        font(.system(size: maximum)).minimumScaleFactor(minimum / maximum)
    }
}

struct ShakeEffect: GeometryEffect {
    private static let cyclesPerShake: CGFloat = 3
    private static let amplitude: CGFloat = 10

    private var shakes: CGFloat

    init(shakes: Int) {
        self.shakes = CGFloat(shakes)
    }

    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(shakes * .pi * 2 * Self.cyclesPerShake) * Self.amplitude
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

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
