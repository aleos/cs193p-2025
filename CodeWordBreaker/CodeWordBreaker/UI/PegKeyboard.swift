//
//  PegKeyboard.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftUI

struct PegKeyboard: View {
    // MARK: Data Out Function
    let onChoose: ((Peg) -> Void)?
            
    // MARK: - Body
    
    var body: some View {
        // Invisible placeholder to establish the correct intrinsic size
        VStack(spacing: Key.spacing) {
            ForEach(0..<Key.rowCount, id: \.self) { _ in
                pegSizeTemplate
            }
        }
        .overlay {
            GeometryReader { geo in
                let pegSize = (geo.size.width - Key.spacing * CGFloat(Key.maxNumber - 1)) / CGFloat(Key.maxNumber)
                VStack(spacing: Key.spacing) {
                    row(for: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"], pegSize: pegSize)
                    row(for: ["A", "S", "D", "F", "G", "H", "J", "K", "L"], pegSize: pegSize)
                    row(for: ["Z", "X", "C", "V", "B", "N", "M"], pegSize: pegSize)
                }
            }
        }
    }
    
    private var pegSizeTemplate: some View {
        HStack(spacing: Key.spacing) {
            ForEach(0..<Key.maxNumber, id: \.self) { _ in
                Color.clear.aspectRatio(1, contentMode: .fit)
            }
        }
    }
    
    func row(for choices: [Peg], pegSize: CGFloat) -> some View {
        HStack(spacing: Key.spacing) {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg)
                        .padding(Key.innerPadding)
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(.gray))
                }
                .frame(width: pegSize, height: pegSize)
            }
        }
    }
}

fileprivate struct Key {
    static let innerPadding: CGFloat = 2
    static let spacing: CGFloat = 10
    static let maxNumber = 10
    static let rowCount = 3
}

#Preview {
    @Previewable @State var selection: Int = 0
    PegKeyboard(onChoose: nil)
}
