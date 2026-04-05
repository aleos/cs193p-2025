//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 6/2/2026.
//

import Foundation
import SwiftData

@Model
final class CodeBreaker {
    var name: String
    @Relationship(deleteRule: .cascade) var masterCode: Code = Code(kind: .master(isHidden: true), numberOfPegs: 4)
    @Relationship(deleteRule: .cascade) var guess: Code = Code(kind: .guess, numberOfPegs: 4)
    @Relationship(deleteRule: .cascade) var attempts: [Code] = []
    var pegChoices: [Peg] = []
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    
    var canAttemptGuess: Bool { !guess.pegs.isEmpty && !guess.hasMissingPegs && !attempts.contains { $0.pegs == guess.pegs } }
    
    init(name: String = "Mastermind") {
        self.name = name
        let theme = Theme.named(name) ?? Theme.random()
        self.name = theme.name
        self.pegChoices = Array(theme.pegs.shuffled().prefix(6))
        restart(numberOfPegs: 4)
    }
    
    init(name: String, pegChoices: [Peg]) {
        self.name = name
        self.pegChoices = pegChoices
        restart()
    }
    
    func startTimer() {
        if startTime != nil, !isOver {
            startTime = .now
            // Nudge a persisted property so SwiftData triggers a UI update
            // (@Transient startTime changes aren't observed)
            elapsedTime += 0.00001
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
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
        elapsedTime = 0
    }
    
    func attemptGuess() {
        guard canAttemptGuess else { return }
        let attempt = Code(kind: .attempt(guess.match(against: masterCode)), pegs: guess.pegs)
        attempts.insert(attempt, at: 0)
        guess.reset()
        if isOver {
            endTime = .now
            masterCode.kind = .master(isHidden: false)
            pauseTimer()
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
