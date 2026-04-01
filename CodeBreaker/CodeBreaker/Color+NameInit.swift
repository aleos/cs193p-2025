import SwiftUI

extension Color {
    init?(name: String) {
        switch name.lowercased() {
        case "red":
            self = .red
        case "green":
            self = .green
        case "blue":
            self = .blue
        case "yellow":
            self = .yellow
        case "orange":
            self = .orange
        case "purple":
            self = .purple
        case "pink":
            self = .pink
        case "primary":
            self = .primary
        case "secondary":
            self = .secondary
        case "black":
            self = .black
        case "white":
            self = .white
        case "gray", "grey":
            self = .gray
        case "clear", "missing":
            self = .clear
        case "brown":
            self = .brown
        case "cyan":
            self = .cyan
        case "indigo":
            self = .indigo
        case "mint":
            self = .mint
        case "teal":
            self = .teal
        default:
            if let hexColor = Color(hex: name) {
                self = hexColor
            } else {
                return nil
            }
        }
    }

    /// Parses a hex string like `"#FF5733"` or `"FF5733"` into a `Color`.
    private init?(hex: String) {
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
