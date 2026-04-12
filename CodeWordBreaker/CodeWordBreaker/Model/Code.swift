//
//  Code.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import Foundation
import SwiftData

@Model
final class Code {
    var _kind: String
    var kind: Kind {
        get { .init(rawValue: _kind) }
        set { _kind = newValue.rawValue }
    }
    var pegs: [Peg] {
        get { word.map(Peg.init) }
        set { word = newValue.joined().lowercased() }
    }
    var timestamp = Date.now
    
    enum Kind: Hashable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    enum Match: String, CaseIterable {
        case nomatch, inexact, exact
    }
    
    var hasMissingPegs: Bool { pegs.contains { $0 == Peg.missing } }
    
    var word: String
    
    init(kind: Kind, word: String) {
        self._kind = kind.rawValue
        self.word = word.lowercased()
    }
    
    convenience init(kind: Kind, pegs: [Peg] = Array<Peg>(repeating: .missing, count: 5)) {
        self.init(kind: kind, word: pegs.joined())
    }
    
    convenience init(kind: Kind, numberOfPegs: Int) {
        self.init(kind: kind, word: String(repeating: Peg.missing, count: numberOfPegs))
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
    private static let separator: String = ":"
    private static let listSeparator: String = ","
    
    var rawValue: String {
        switch self {
        case .master(let isHidden): "master" + Self.separator + "\(isHidden)"
        case .guess: "guess"
        case .attempt(let matches): "attempt" + Self.separator + matches.map(\.rawValue).joined(separator: Self.listSeparator)
        case .unknown: "unknown"
        }
    }
    
    init(rawValue: String) {
        let parts = rawValue.split(separator: Self.separator, maxSplits: 1)
        switch parts.first.map(String.init) {
        case "master":
            self = .master(isHidden: parts.last.map(String.init).map(Bool.init) != false)
        case "guess":
            self = .guess
        case "attempt":
            let tokens = parts.last?.split(separator: Self.listSeparator)
            let matches = tokens?.compactMap { Code.Match(rawValue: String($0)) } ?? []
            self = .attempt(matches)
        default:
            self = .unknown
        }
    }
}

extension Code.Match: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        let order = allCases
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}

