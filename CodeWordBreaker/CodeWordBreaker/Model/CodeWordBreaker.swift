//
//  CodeWordBreaker.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import Foundation
import SwiftData

@Model
final class CodeWordBreaker {
    static let defaultNumberOfLetters: Int = 5
    
    @Relationship(deleteRule: .cascade) var masterCode = Code(kind: .master(isHidden: true), numberOfPegs: defaultNumberOfLetters)
    @Relationship(deleteRule: .cascade) var guess = Code(kind: .guess, numberOfPegs: defaultNumberOfLetters)
    @Relationship(deleteRule: .cascade) var _attempts: [Code] = []
    @Transient private(set) var startTime: Date?
    private(set) var elapsedTime: TimeInterval = 0
    private(set) var endTime: Date?
    private(set) var lastAttemptedAt: Date?
    private(set) var created = Date.now
    
    var canAttemptGuess: Bool { !guess.pegs.isEmpty && !guess.hasMissingPegs && !attempts.contains { $0.pegs == guess.pegs } }
    
    var attempts: [Code] {
        get { _attempts.sorted { $0.timestamp > $1.timestamp } }
        set { _attempts = newValue }
    }
    
    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }
    
    init(word: String? = nil) {
        restart(masterWord: word)
    }
    
    func restart(numberOfPegs: Int? = nil, masterWord: String? = nil) {
        let numberOfPegs = numberOfPegs ?? masterWord?.count ?? masterCode.pegs.count
        masterCode = Code(kind: .master(isHidden: true), numberOfPegs: numberOfPegs)
        if let word = masterWord {
            masterCode.word = word
        } else {
            masterCode.reset()
        }
        guess = Code(kind: .guess, numberOfPegs: numberOfPegs)
        attempts.removeAll()
        endTime = nil
    }
    
    func attemptGuess() {
        guard canAttemptGuess else { return }
        let attempt = Code(kind: .attempt(guess.match(against: masterCode)), pegs: guess.pegs)
        attempts.append(attempt)
        lastAttemptedAt = .now
        print("Attempt: \(attempt.word)")
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
            pause()
            endTime = .now
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func bestResult(for peg: Peg) -> Code.Match? {
        let pegMatches = attempts.flatMap { attempt in
            zip(attempt.pegs, attempt.matches ?? []).map { (peg: $0, match: $1) }
        }
        return pegMatches.filter { $0.peg == peg }.map(\.match).max()
    }
    
    func resume() {
        guard !isOver else { return }
        // Nudge a persisted property so SwiftData triggers a UI update
        // (@Transient startTime changes aren't observed)
        elapsedTime += 0.00001
        startTime = .now
    }
    
    func pause() {
        guard let startTime else { return }
        self.startTime = nil
        elapsedTime += Date.now.timeIntervalSince(startTime)
    }
}

extension CodeWordBreaker {
    static var sample: CodeWordBreaker { [CodeWordBreaker].samples.first ?? .init() }
}

extension Array where Element == CodeWordBreaker {
    static var samples: Self {
        let apple = CodeWordBreaker(word: "apple")
        makeAttempts(["truck"], in: apple)
        let swift = CodeWordBreaker(word: "swift")
        makeAttempts(["house", "plant", "water", "beach", "swift"], in: swift)
        let quick = CodeWordBreaker(word: "quick")
        let dirty = CodeWordBreaker(word: "dirty")
        let sweet = CodeWordBreaker(word: "sweet")
        makeAttempts(["bread", "light", "grass", "chair", "dream", "flame", "truck", "shelf", "paint", "guard", "clock", "storm", "train", "smile"], in: sweet)
        
        return [apple, swift, quick, dirty, sweet]
    }
    
    private static func makeAttempts(_ words: [String], in game: CodeWordBreaker) {
        for word in words {
            let guess = Code(kind: .guess, numberOfPegs: CodeWordBreaker.defaultNumberOfLetters)
            guess.word = word
            game.guess = guess
            game.attemptGuess()
        }
    }
}
