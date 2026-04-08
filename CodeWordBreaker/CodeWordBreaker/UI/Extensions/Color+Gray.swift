//
//  Color+Gray.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 8/4/2026.
//

import SwiftUI

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        .init(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    VStack(spacing: 0) {
        ForEach(Array(stride(from: 0, through: 1, by: 0.05)), id: \.self) {
            let _ = print($0)
            Color.gray($0)
        }
    }
    .ignoresSafeArea(.all)
}
