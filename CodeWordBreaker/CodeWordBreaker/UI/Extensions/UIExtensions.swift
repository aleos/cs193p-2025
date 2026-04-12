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
