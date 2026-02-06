//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 31/1/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    let game: CodeBreaker = CodeBreaker()
    
    var body: some View {
        VStack {
            pegs(colors: [.red, .green, .green, .yellow])
            pegs(colors: [.red, .blue, .green, .red])
            pegs(colors: [.red, .yellow, .green, .blue])
        }
        .padding()
    }
    
    func pegs(colors: [Color]) -> some View {
        HStack {
            ForEach(colors.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colors[index])
            }
            MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        }
    }
}

#Preview {
    CodeBreakerView()
}
