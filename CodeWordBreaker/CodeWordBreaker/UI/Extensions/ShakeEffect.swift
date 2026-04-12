//
//  ShakeEffect.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 12/4/2026.
//

import SwiftUI

extension View {
    func shake(shakes: Int) -> some View {
        self.modifier(ShakeEffect(shakes: shakes))
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

#Preview {
    @Previewable @State var shakes: Int = 0
    VStack(spacing: 32) {
        Text("Hello, world!")
            .shake(shakes: shakes)
        Button("Tap me") {
            withAnimation(.linear(duration: 0.4)) {
                shakes += 1
            }
        }
        .buttonStyle(.glassProminent)
    }
}
