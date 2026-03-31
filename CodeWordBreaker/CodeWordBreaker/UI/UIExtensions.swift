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

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        .init(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }

    init?(hex: String) {
        guard hex.hasPrefix("#"), hex.count == 7,
              let value = UInt(hex.dropFirst(), radix: 16) else { return nil }
        self.init(value)
    }

    var hex: String { UIColor(self).hex }
}

extension UIColor {
    var hex: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int((r * 255).rounded()), Int((g * 255).rounded()), Int((b * 255).rounded()))
    }
}
