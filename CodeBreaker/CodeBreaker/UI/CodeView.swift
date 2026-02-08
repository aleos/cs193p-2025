//
//  CodeView.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 7/2/2026.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data In
    let code: Code
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    init(
        code: Code,
        selection: Binding<Int> = .constant(-1),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        _selection = selection
        self.ancillaryView = ancillaryView
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                    .padding(Selection.border)
                    .background {
                        if selection == index, code.kind == .guess {
                            Selection.shape
                                .foregroundStyle(Selection.color)
                        }
                    }
                    .overlay {
                        Selection.shape.foregroundStyle(code.isHidden ? .gray : .clear)
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay { ancillaryView() }
        }
    }
}

fileprivate struct Selection {
    static let border: CGFloat = 5
    static let cornerRadius: CGFloat = 10
    static let color: Color = Color.gray(0.85)
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}

#Preview {
    @Previewable @State var selection: Int = 0
    CodeView(code: .init(kind: .guess, numberOfPegs: 4), selection: $selection) { Color.teal }
}
