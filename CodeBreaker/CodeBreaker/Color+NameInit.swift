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
            return nil
        }
    }
}
