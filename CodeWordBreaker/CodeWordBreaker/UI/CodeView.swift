//
//  CodeView.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data In
    let code: Code
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: Data (sort of) In Function
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    // MARK: Data Owned by Me
    @Namespace private var selectionNamespace
    
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
                    .background { selectionBackground(for: index) }
                    .overlay { hiddenCodeOverlay }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
            let ancillary = ancillaryView()
            if !(ancillary is EmptyView) {
                Color.clear.aspectRatio(1, contentMode: .fit)
                    .overlay { ancillary }
            }
        }
    }
    
    @ViewBuilder
    private func selectionBackground(for index: Int) -> some View {
        switch code.kind {
        case .attempt(let matches):
            Selection.shape
                .foregroundStyle(matches[index].color)
        case .guess:
            Group {
                if selection == index {
                    Selection.shape
                        .foregroundStyle(Selection.color)
                        .matchedGeometryEffect(
                            id: "selection",
                            in: selectionNamespace
                        )
                }
            }
            .animation(.selection, value: selection)
        case .master, .unknown:
            EmptyView()
        }
    }
    
    private var hiddenCodeOverlay: some View {
        Selection.shape.foregroundStyle(code.isHidden ? .gray : .clear)
            .transaction { transaction in
                if code.isHidden {
                    transaction.animation = nil
                }
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
    CodeView(code: .init(kind: .guess, numberOfPegs: 4), selection: $selection)
}
