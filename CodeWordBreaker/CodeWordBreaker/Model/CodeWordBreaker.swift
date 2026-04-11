//
//  CodeWordBreaker.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import Foundation

typealias Peg = String

extension Peg {
    static let missing = " "
}

@Observable
final class CodeWordBreaker {
    static let defaultNumberOfLetters: Int = 5
    
    var masterCode: Code = .init(kind: .master(isHidden: true), numberOfPegs: defaultNumberOfLetters)
    var guess: Code = .init(kind: .guess, numberOfPegs: defaultNumberOfLetters)
    var attempts: [Code] = []
    private(set) var startTime: Date?
    private(set) var elapsedTime: TimeInterval = 0
    private(set) var endTime: Date?
    private(set) var lastAttemptedAt: Date?
    
    var canAttemptGuess: Bool { !guess.pegs.isEmpty && !guess.hasMissingPegs && !attempts.contains { $0.pegs == guess.pegs } }
    
    init(word: String? = nil) {
        restart(masterWord: word)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
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
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        lastAttemptedAt = .now
        print("Attempt: \(attempt)")
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
    
    func bestResult(for peg: Peg) -> Match? {
        let pegMatches = attempts.flatMap { attempt in
            zip(attempt.pegs, attempt.matches ?? []).map { (peg: $0, match: $1) }
        }
        return pegMatches.filter { $0.peg == peg }.map(\.match).max()
    }
    
    func resume() {
        guard endTime == nil else { return }
        startTime = .now
    }
    
    func pause() {
        guard let startTime else { return }
        self.startTime = nil
        elapsedTime += Date.now.timeIntervalSince(startTime)
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
        let sweet = CodeWordBreaker(word: "sweet")
        makeAttempts(["bread", "light", "grass", "chair", "dream", "flame", "truck", "shelf", "paint", "guard", "clock", "storm", "train", "smile"], in: sweet)
        
        return [apple, swift, quick, sweet]
    }
    
    private static func makeAttempts(_ words: [String], in game: CodeWordBreaker) {
        for word in words {
            var guess = Code(kind: .guess, numberOfPegs: CodeWordBreaker.defaultNumberOfLetters)
            guess.word = word
            game.guess = guess
            game.attemptGuess()
        }
    }
}
