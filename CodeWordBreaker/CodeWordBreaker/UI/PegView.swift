//
//  PegView.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    var body: some View {
        Text(peg)
            .font(.system(size: 120))
            .minimumScaleFactor(9/120)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    VStack {
        PegView(peg: "A")
        PegView(peg: Peg.missing)
    }
    .padding()
}
