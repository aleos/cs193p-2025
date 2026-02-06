//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 6/2/2026.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts: [Code]
    var pegChoices: [Peg]
    
    
}

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    enum Kind {
        case master, guess, attempt, unknown
    }
}
