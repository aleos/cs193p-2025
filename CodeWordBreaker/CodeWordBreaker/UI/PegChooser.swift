//
//  PegChooser.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftUI

struct PegChooser: View {
    // MARK: Data In
    let choices: [Peg]
    
    // MARK: Data Out Function
    let onChoose: ((Peg) -> Void)?
    
    @State private var measuredWidth: CGFloat = 200
        
    // MARK: - Body
    
    var body: some View {
        VStack {
            row(for: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"], width: measuredWidth - Key.outerPadding)
            row(for: ["a", "s", "d", "f", "g", "h", "j", "k", "l"], width: measuredWidth - Key.outerPadding)
            row(for: ["z", "x", "c", "v", "b", "n", "m"], width: measuredWidth - Key.outerPadding)
        }
        .overlay(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: WidthPreferenceKey.self, value: proxy.size.width)
            }
        )
        .onPreferenceChange(WidthPreferenceKey.self) { newWidth in
            measuredWidth = newWidth
        }
    }
    
    func row(for choices: [Peg], width: CGFloat) -> some View {
        HStack {
            Spacer()
            HStack(spacing: Key.spacing) {
                ForEach(choices, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg)
                            .padding(Key.innerPadding)
                            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(.gray))
                    }
                    .frame(width: width / CGFloat(Key.maxNumber) - Key.spacing)
                }
            }
            Spacer()
        }
    }
}

fileprivate struct Key {
    static let outerPadding: CGFloat = 0
    static let innerPadding: CGFloat = 2
    static let spacing: CGFloat = 10
    static let maxNumber = 10
}

private struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    @Previewable @State var selection: Int = 0
    PegChooser(choices: ["blue", "green", "yellow"], onChoose: nil)
}
