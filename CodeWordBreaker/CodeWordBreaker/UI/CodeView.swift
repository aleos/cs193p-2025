//
//  CodeView.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data In
    @Environment(\.settings) private var settings
    let code: Code
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: Data (sort of) In Function
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    // MARK: Data Owned by Me
    @Namespace private var selectionNamespace
    @State private var poppingIndex: Int?
    
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
                    .opacity(code.isHidden ? 0 : 1)
                    .transaction { transaction in
                        if code.isHidden {
                            transaction.animation = nil
                        }
                    }
                    .scaleEffect(poppingIndex == index ? 1.15 : 1)
                    .animation(.bouncy(duration: 0.15), value: poppingIndex)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(Selection.border)
                    .background { pegBackground(for: index) }
                    .overlay { hiddenCodeOverlay }
                    .matchedGeometryEffect(
                        id: index,
                        in: selectionNamespace,
                        isSource: code.kind == .guess
                    )
                    .onChange(of: code.pegs[index]) {
                        guard code.kind == .guess, code.pegs[index] != .missing else { return }
                        withAnimation(.easeOut(duration: 0.1)) {
                            poppingIndex = index
                        } completion: {
                            withAnimation(.easeIn(duration: 0.1)) {
                                poppingIndex = nil
                            }
                        }
                    }
                    .transition(.opacity)
            }
            let ancillary = ancillaryView()
            if !(ancillary is EmptyView) {
                Color.clear.aspectRatio(1, contentMode: .fit)
                    .overlay { ancillary }
            }
        }
        .background {
            if code.kind == .guess, selection >= 0 {
                Selection.shape
                    .foregroundStyle(Selection.color)
                    .matchedGeometryEffect(
                        id: selection,
                        in: selectionNamespace,
                        properties: .frame,
                        isSource: false
                    )
                    .animation(.selection, value: selection)
            }
        }
    }
    
    @ViewBuilder
    private func pegBackground(for index: Int) -> some View {
        switch code.kind {
        case .attempt(let matches):
            if code.hasMissingPegs {
                Selection.shape
                    .strokeBorder(.gray)
            } else {
                Selection.shape
                    .foregroundStyle(settings.color(for: matches[index]))
            }
        default:
            EmptyView()
        }
    }
    
    private var hiddenCodeOverlay: some View {
        Selection.shape.foregroundStyle(code.isHidden ? .gray : .clear)
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
    CodeView(code: .init(kind: .guess, word: "alex"), selection: $selection)
    CodeView(code: .init(kind: .attempt([.nomatch, .inexact, .exact, .exact]), numberOfPegs: 4))
}
