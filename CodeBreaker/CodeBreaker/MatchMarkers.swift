//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 5/2/2026.
//

import SwiftUI

enum Match {
    case nomatch, exact, inexact
}

struct MatchMarkers: View {
    var matches: [Match]
    
    var body: some View {
        HStack {
            ForEach(0..<(matches.count + 1)/2, id: \.self) { matchGroup in
                VStack {
                    let startIndex = matchGroup * 2
                    ForEach(startIndex..<startIndex + 2, id: \.self) { index in
                        matchMarker(peg: index)
                    }
                }
            }
        }
    }
    
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count(where: { $0 == .exact })
        let foundCount = matches.count(where: { $0 != .nomatch })
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    VStack {
        Spacer()
        ForEach(1...9, id: \.self) {_ in
            MatchMarkersPreview()
            Spacer()
        }
    }
    .padding()
}

struct MatchMarkersPreview: View {
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) {_ in
                Circle()
            }
            MatchMarkers(matches: [.exact, .inexact, .inexact, .exact, .exact])
        }
    }
}
