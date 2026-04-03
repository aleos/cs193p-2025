//
//  PegChoicesChooser.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 1/4/2026.
//

import SwiftUI

struct PegChoicesChooser: View {
    // MARK: Data Shared with Me
    @Binding var pegChoices: [Peg]

    var body: some View {
        List {
            ForEach(pegChoices.indices, id: \.self) { index in
                ColorPicker(
                    selection: .init(
                        get: { Color(hex: pegChoices[index]) ?? .clear },
                        set: { pegChoices[index] = $0.hex }
                    ),
                    supportsOpacity: false
                ) {
                    button("Peg Choice \(index + 1)", systemImage: "minus.circle", color: .red) {
                        pegChoices.remove(at: index)
                    }
                }
            }
            button("Add Peg", systemImage: "plus.circle", color: .green) {
                pegChoices.append(Color.green.hex)
            }
        }
    }
    
    private func button(
        _ title: String,
        systemImage: String,
        color: Color? = nil,
        action: @escaping () -> Void
    ) -> some View {
        HStack {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Image(systemName: systemImage)
                    .tint(color)
                    .imageScale(.large)
            }
            Text(title)
        }
    }
}

#Preview {
    @Previewable @State var pegChoices: [Peg] = [
        Color.teal.hex, "#00F000", Color.red.hex, Color.yellow.hex,
    ]
    PegChoicesChooser(pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("pegChoices = \(pegChoices)")
        }
}
