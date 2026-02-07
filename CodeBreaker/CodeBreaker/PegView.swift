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
    
    let pegShape = Circle()
    
    var body: some View {
        pegShape
            .foregroundStyle(Color(name: peg) ?? .clear)
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                if peg == Peg.missing {
                    pegShape
                        .strokeBorder(.gray)
                }
            }
    }
}

#Preview {
    PegView(peg: "teal")
        .padding()
}
