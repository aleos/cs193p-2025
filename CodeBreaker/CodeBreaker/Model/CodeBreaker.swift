//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 6/2/2026.
//

import Foundation

typealias Peg = String

extension Peg {
    static let missing = ""
}

struct Theme {
    var name: String
    var pegs: [Peg]
    
    static let all: [Theme] = [
        Theme(name: "Mastermind", pegs: ["red", "green", "blue", "yellow", "orange", "purple"]),
        Theme(name: "Faces", pegs: ["😀", "😂", "😍", "😎", "🤔", "😡"]),
        Theme(name: "Vehicles", pegs: ["🚗", "🚌", "🚲", "🚁", "🚀", "🚂"]),
        Theme(name: "Animals", pegs: ["🐶", "🐱", "🦊", "🐼", "🐸", "🐵"]),
        Theme(name: "Food", pegs: ["🍎", "🍔", "🍣", "🍕", "🍩", "🍇"]),
        Theme(name: "Sports", pegs: ["⚽️", "🏀", "🏈", "🎾", "🏐", "🏓"])
    ]
    
    static let `default` = Theme(name: "Colors (classic)", pegs: ["red", "green", "blue", "yellow", "orange", "purple"])
    
    static func random() -> Theme {
        all.randomElement() ?? .default
    }
    
    static func named(_ name: String) -> Theme? {
        all.first { $0.name == name }
    }
}

@Observable class CodeBreaker {
    var name: String
    var masterCode: Code = .init(kind: .master(isHidden: true), numberOfPegs: 4)
    var guess: Code = .init(kind: .guess, numberOfPegs: 4)
    var attempts: [Code] = []
    var pegChoices: [Peg] = []
    var startTime = Date.now
    var endTime: Date?
    
    var canAttemptGuess: Bool { !guess.pegs.isEmpty && !guess.hasMissingPegs && !attempts.contains { $0.pegs == guess.pegs } }
    
    init(name: String = "Mastermind") {
        self.name = name
        let theme = Theme.named(name) ?? Theme.random()
        self.name = theme.name
        self.pegChoices = Array(theme.pegs.shuffled().prefix(masterCode.pegs.count))
        restart()
    }
    
    init(name: String, pegChoices: [Peg]) {
        self.name = name
        self.pegChoices = pegChoices
        restart()
    }
    
    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }
    
    func restart(numberOfPegs: Int? = nil) {
        let numberOfPegs = numberOfPegs ?? masterCode.pegs.count
        masterCode = Code(kind: .master(isHidden: true), numberOfPegs: numberOfPegs)
        masterCode.randomize(from: pegChoices)
        guess = Code(kind: .guess, numberOfPegs: numberOfPegs)
        attempts.removeAll()
        startTime = .now
        endTime = nil
    }
    
    func attemptGuess() {
        guard canAttemptGuess else { return }
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.insert(attempt, at: 0)
        guess.reset()
        if isOver {
            endTime = .now
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Peg.missing
        }
    }
}

extension CodeBreaker: Identifiable, Hashable {
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
