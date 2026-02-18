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
        
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selection: Int = 0
    PegChooser(choices: ["blue", "green", "yellow"], onChoose: nil)
}
