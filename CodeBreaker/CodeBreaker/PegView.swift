//
//  PegView.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 7/2/2026.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(Color(name: peg) ?? .clear)
            .contentShape(Rectangle())
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                if peg == Peg.missing {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.gray)
                }
            }
    }
}

#Preview {
    PegView(peg: "teal")
        .padding()
}
