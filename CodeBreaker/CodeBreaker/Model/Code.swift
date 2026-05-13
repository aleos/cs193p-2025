//
//  Code.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 7/2/2026.
//

import Foundation
import SwiftData

@Model
final class Code {
    var _kind: String
    var kind: Kind {
        get { .init(rawValue: _kind) ?? .unknown }
        set { _kind = newValue.rawValue }
    }
    var pegs: [Peg]
    var timestamp = Date.now
    
    init(kind: Kind, pegs: [Peg] = Array<Peg>(repeating: .missing, count: 4)) {
        self._kind = kind.rawValue
        self.pegs = pegs
    }
    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    enum Match: String {
        case nomatch, exact, inexact
    }
    
    var hasMissingPegs: Bool { pegs.contains { $0 == Peg.missing } }
    
    init(kind: Kind, numberOfPegs: Int) {
        self._kind = kind.rawValue
        self.pegs = Array(repeating: Peg.missing, count: numberOfPegs)
    }
    
    func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Peg.missing
        }
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): isHidden
        default: false
        }
    }
    
    func reset() {
        pegs = Array(repeating: Peg.missing, count: pegs.count)
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): matches
        default: nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        
        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }
        
        let exactMatches = Array(backwardsExactMatches.reversed())
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
    }
}

extension Code.Kind: RawRepresentable {
    var rawValue: String {
        switch self {
        case .master(let isHidden): "master:\(isHidden)"
        case .guess: "guess"
        case .attempt(let matches): "attempt:" + matches.map(\.rawValue).joined(separator: ",")
        case .unknown: "unknown"
        }
    }
    
    init?(rawValue: String) {
        let parts = rawValue.split(separator: ":", maxSplits: 1)
        switch parts.first.map(String.init) {
        case "master":
            self = .master(isHidden: parts.last == "true")
        case "guess":
            self = .guess
        case "attempt":
            let matches = parts.last?.split(separator: ",").compactMap { Code.Match(rawValue: String($0)) } ?? []
            self = .attempt(matches)
        default:
            self = .unknown
        }
    }
}
