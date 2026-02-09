//
//  Code.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 7/2/2026.
//

import Foundation

struct Code {
    var kind: Kind
    var pegs: [Peg]
        
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    var hasMissingPegs: Bool { pegs.contains { $0 == Peg.missing } }
    
    init(kind: Kind, numberOfPegs: Int) {
        self.kind = kind
        self.pegs = Array(repeating: Peg.missing, count: numberOfPegs)
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Peg.missing
        }
        print(self)
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): isHidden
        default: false
        }
    }
    
    mutating func reset() {
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
