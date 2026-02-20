//
//  CodeWordBreaker.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import Foundation

typealias Peg = String

extension Peg {
    static let missing = ""
}

struct CodeWordBreaker {
    var masterCode: Code = .init(kind: .master(isHidden: true), numberOfPegs: 4)
    var guess: Code = .init(kind: .guess, numberOfPegs: 4)
    var attempts: [Code] = []
    private(set) var selectedTheme = ""
    private(set) var pegChoices: [Peg] = []
    
    var canAttemptGuess: Bool { !guess.pegs.isEmpty && !guess.hasMissingPegs && !attempts.contains { $0.pegs == guess.pegs } }
    
    init() {
        restart()
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func restart(numberOfPegs: Int? = nil) {
        let numberOfPegs = numberOfPegs ?? masterCode.pegs.count
        self.selectedTheme = "alphabet"
        self.pegChoices = (UnicodeScalar("a").value...UnicodeScalar("z").value)
            .compactMap { UnicodeScalar($0)}
            .map { String($0) }
        masterCode = Code(kind: .master(isHidden: true), numberOfPegs: numberOfPegs)
        masterCode.randomize(from: pegChoices)
        guess = Code(kind: .guess, numberOfPegs: numberOfPegs)
        attempts.removeAll()
    }
    
    mutating func attemptGuess() {
        guard canAttemptGuess else { return }
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Peg.missing
        }
    }
}

