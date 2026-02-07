//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 6/2/2026.
//

import Foundation

typealias Peg = String

struct Theme {
    var name: String
    var pegs: [Peg]
    
    static let all: [Theme] = [
        Theme(name: "Colors (classic)", pegs: ["red", "green", "blue", "yellow", "orange", "purple"]),
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
}

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    let selectedTheme: String
    let pegChoices: [Peg]
    
    var canAttemptGuess: Bool { !guess.pegs.isEmpty && !guess.hasMissingPegs && !attempts.contains { $0.pegs == guess.pegs } }
    
    init(numberOfPegs: Int = 4) {
        print("Number of pegs: \(numberOfPegs)")
        let theme = Theme.random()
        self.selectedTheme = theme.name
        self.pegChoices = Array(theme.pegs.shuffled().prefix(numberOfPegs))
        masterCode = Code(kind: .master, numberOfPegs: numberOfPegs)
        masterCode.randomize(from: pegChoices)
        guess = Code(kind: .guess, numberOfPegs: numberOfPegs)
        print(masterCode)
    }
    
    mutating func attemptGuess() {
        guard canAttemptGuess else { return }
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
}

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    static let missing: Peg = "clear"
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    var hasMissingPegs: Bool { pegs.contains { $0 == Code.missing } }
    
    init(kind: Kind, numberOfPegs: Int) {
        self.kind = kind
        self.pegs = Array(repeating: Code.missing, count: numberOfPegs)
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): matches
        default: nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
}

