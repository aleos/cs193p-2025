//
//  Color+Hex.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 3/4/2026.
//

import SwiftUI

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

#Preview {
    VStack(spacing: 0) {
        ForEach(Array(stride(from: 0x000000, through: 0xFFFFFF, by: 0xC0DE)), id: \.self) {
            Color(UInt($0), alpha: 1)
        }
    }
    .ignoresSafeArea(.all)
}
