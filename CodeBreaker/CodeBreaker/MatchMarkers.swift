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
    let configurations: [[Match]] = [
        [.exact, .inexact, .inexact],
        [.exact, .nomatch, .nomatch],
        [.exact, .inexact, .inexact, .exact, .nomatch],
        [.exact, .inexact, .nomatch, .exact],
        [.exact, .inexact],
        [.exact, .inexact, .exact, .exact],
        [.exact, .inexact, .inexact, .exact, .exact, .inexact],
        [.exact, .inexact, .inexact, .exact, .inexact],
        [.exact, .inexact, .inexact],
    ]
    VStack(alignment: .leading) {
        Spacer()
        ForEach(configurations, id: \.self) { matches in
            MatchMarkersPreview(matches: matches)
            Spacer()
        }
    }
    .padding()
}

struct MatchMarkersPreview: View {
    let matches: [Match]
    var body: some View {
        HStack {
            ForEach(1...matches.count, id: \.self) {_ in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
            }
            MatchMarkers(matches: matches)
        }
        .frame(maxHeight: 40)
    }
}
