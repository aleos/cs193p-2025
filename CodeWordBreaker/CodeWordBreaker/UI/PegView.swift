//
//  PegView.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    let pegShape = Circle()
    
    var body: some View {
        let pegColor = Color(name: peg)
        pegShape
            .foregroundStyle(pegColor ?? .clear)
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                if pegColor == nil {
                    Text(peg)
                        .font(.system(size: 120))
                        .minimumScaleFactor(9/120)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
}

#Preview {
    PegView(peg: "teal")
        .padding()
}

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
