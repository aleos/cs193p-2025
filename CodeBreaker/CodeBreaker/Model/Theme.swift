//
//  Theme.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 3/4/2026.
//


struct Theme {
    var name: String
    var pegs: [Peg]
    
    static let all: [Theme] = [
        Theme(name: "Mastermind", pegs: [.red, .blue, .green, .yellow]),
        Theme(name: "Earth Tones", pegs: [.orange, .brown, .black, .yellow, .green]),
        Theme(name: "Undersea", pegs: [.blue, .purple, .teal]),
        Theme(name: "Faces", pegs: ["😀", "😂", "😍", "😎", "🤔", "😡"]),
        Theme(name: "Vehicles", pegs: ["🚗", "🚌", "🚲", "🚁", "🚀", "🚂"]),
        Theme(name: "Animals", pegs: ["🐶", "🐱", "🦊", "🐼", "🐸", "🐵"]),
        Theme(name: "Food", pegs: ["🍎", "🍔", "🍣", "🍕", "🍩", "🍇"]),
        Theme(name: "Sports", pegs: ["⚽️", "🏀", "🏈", "🎾", "🏐", "🏓"])
    ]
    
    static let `default` = Theme(name: "Colors (classic)", pegs: [.red, .green, .blue, .yellow, .orange, .purple])
    
    static func random() -> Theme {
        all.randomElement() ?? .default
    }
    
    static func named(_ name: String) -> Theme? {
        all.first { $0.name == name }
    }
}
