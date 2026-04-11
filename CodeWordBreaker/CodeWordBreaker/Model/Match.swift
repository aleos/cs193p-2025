//
//  Match.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

enum Match: String, CaseIterable {
    case nomatch, inexact, exact
}

extension Match: Comparable {
    static func < (lhs: Match, rhs: Match) -> Bool {
        let order = allCases
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
