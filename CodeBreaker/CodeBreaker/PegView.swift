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
        let pegColor = Color(name: peg)
        pegShape
            .foregroundStyle(pegColor ?? .clear)
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                if pegColor == nil {
                    Text(peg)
                        .font(.system(size: 120))
                        .minimumScaleFactor(9/120)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
}

#Preview {
    PegView(peg: "teal")
        .padding()
}
