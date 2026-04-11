//
//  PegKeyboard.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftUI

struct PegKeyboard: View {
    // MARK: Data In
    @Environment(\.settings) private var settings
    
    // MARK: Data Out Function
    let onChoose: ((Peg) -> Void)?
    let onErase: (() -> Void)?
    let onGuess: (() -> Void)?
    var canGuess: Bool = true
    var bestResult: ((Peg) -> Code.Match?)? = nil
    
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
                    HStack {
                        guessButton
                            .frame(width: pegSize * 1.5)
                        Spacer()
                        row(for: ["Z", "X", "C", "V", "B", "N", "M"], pegSize: pegSize)
                        Spacer()
                        eraseButton
                            .frame(width: pegSize * 1.5)
                    }
                }
            }
        }
    }
    
    private var pegSizeTemplate: some View {
        HStack(spacing: Key.spacing) {
            ForEach(0..<Key.maxNumber, id: \.self) { _ in
                Color.clear.aspectRatio(Key.aspectRatio, contentMode: .fit)
            }
        }
    }
    
    private var guessButton: some View {
        Button(action: onGuess ?? {}) {
            PegView(peg: "⏎")
                .padding(Key.innerPadding)
                .background(
                    Key.shape.strokeBorder(Key.borderColor)
                        .background(Key.shape.foregroundStyle(Key.color))
                )
        }
        .tint(.primary)
        .disabled(!canGuess)
        .aspectRatio(Key.aspectRatio * 1.5, contentMode: .fit)
    }
    
    private var eraseButton: some View {
        Button(action: onErase ?? {}) {
            PegView(peg: "⌫")
                .padding(Key.innerPadding)
                .background(
                    Key.shape.strokeBorder(Key.borderColor)
                        .background(Key.shape.foregroundStyle(Key.color))
                )
        }
        .tint(.primary)
        .aspectRatio(Key.aspectRatio * 1.5, contentMode: .fit)
    }
    
    func row(for choices: [Peg], pegSize: CGFloat) -> some View {
        HStack(spacing: Key.spacing) {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    let keyColor = bestResult?(peg).flatMap(settings.color)?.opacity(0.5)
                    PegView(peg: peg)
                        .padding(Key.innerPadding)
                        .background(
                            Key.shape.strokeBorder(Key.borderColor)
                                .background {
                                    if let keyColor {
                                        Key.shape.foregroundStyle(keyColor)
                                    } else {
                                        Key.shape.foregroundStyle(Key.color)
                                    }
                                }
                        )
                }
                .tint(.primary)
                .aspectRatio(Key.aspectRatio, contentMode: .fit)
                .frame(width: pegSize)
            }
        }
    }
}

fileprivate struct Key {
    static let shape = RoundedRectangle(cornerRadius: 5)
    static let aspectRatio: CGFloat = 3/4
    static let innerPadding: CGFloat = 4
    static let spacing: CGFloat = 10
    static let maxNumber = 10
    static let rowCount = 3
    static let borderColor: Color = Color.gray(0.85)
    static let color: BackgroundStyle = .background
}

#Preview {
    @Previewable @State var selection: Int = 0
    PegKeyboard(onChoose: { print("Choose \($0)") }, onErase: { print("Backspace") }, onGuess: { print("Guess") }, bestResult: nil)
}
