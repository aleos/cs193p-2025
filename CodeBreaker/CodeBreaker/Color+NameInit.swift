import SwiftUI

extension Peg {
    static let red = Color.red.toHex()
    static let green = Color.green.toHex()
    static let blue = Color.blue.toHex()
    static let yellow = Color.yellow.toHex()
    static let orange = Color.orange.toHex()
    static let purple = Color.purple.toHex()
    static let pink = Color.pink.toHex()
    static let black = Color.black.toHex()
    static let white = Color.white.toHex()
    static let gray = Color.gray.toHex()
    static let brown = Color.brown.toHex()
    static let cyan = Color.cyan.toHex()
    static let indigo = Color.indigo.toHex()
    static let mint = Color.mint.toHex()
    static let teal = Color.teal.toHex()
}

extension Color {
    /// Parses a hex string like `"#FF5733"` or `"FF5733"` into a `Color`.
    init?(hex: String) {
        var hex = hex
        if hex.hasPrefix("#") { hex.removeFirst() }
        guard hex.count == 6, let rgb = UInt64(hex, radix: 16) else { return nil }
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }

    /// Resolves the colour to a `#RRGGBB` hex string.
    func toHex(in environment: EnvironmentValues = .init()) -> String {
        let resolved = resolve(in: environment)
        let r = max(0, min(255, Int(resolved.red * 255)))
        let g = max(0, min(255, Int(resolved.green * 255)))
        let b = max(0, min(255, Int(resolved.blue * 255)))
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
