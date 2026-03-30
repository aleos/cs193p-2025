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

@Observable class CodeWordBreaker {
    var masterCode: Code = .init(kind: .master(isHidden: true), numberOfPegs: 4)
    var guess: Code = .init(kind: .guess, numberOfPegs: 4)
    var attempts: [Code] = []
    private(set) var selectedTheme = ""
    
    var canAttemptGuess: Bool { !guess.pegs.isEmpty && !guess.hasMissingPegs && !attempts.contains { $0.pegs == guess.pegs } }
    
    init(word: String? = nil) {
        restart(masterWord: word)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    func restart(numberOfPegs: Int? = nil, masterWord: String? = nil) {
        let numberOfPegs = numberOfPegs ?? masterCode.pegs.count
        self.selectedTheme = "words"
        masterCode = Code(kind: .master(isHidden: true), numberOfPegs: numberOfPegs)
        if let word = masterWord {
            masterCode.word = word
        } else {
            masterCode.reset()
        }
        guess = Code(kind: .guess, numberOfPegs: numberOfPegs)
        attempts.removeAll()
    }
    
    func attemptGuess() {
        guard canAttemptGuess else { return }
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        print("Attempt: \(attempt)")
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func bestResult(for peg: Peg) -> Match? {
        let pegMatches = attempts.flatMap { attempt in
            zip(attempt.pegs, attempt.matches ?? []).map { (peg: $0, match: $1) }
        }
        return pegMatches.filter { $0.peg == peg }.map(\.match).max()
    }
}

extension CodeWordBreaker: Identifiable, Hashable {
    static func == (lhs: CodeWordBreaker, rhs: CodeWordBreaker) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
