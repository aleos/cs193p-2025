//
//  Theme.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 3/4/2026.
//

import SwiftUI

struct Theme {
    var name: String
    var pegs: [Peg]
    
    static let all: [Theme] = [
        Theme(name: "Mastermind", pegs: [Color.red, .blue, .green, .yellow].map(\.hex)),
        Theme(name: "Earth Tones", pegs: [Color.orange, .brown, .black, .yellow, .green].map(\.hex)),
        Theme(name: "Undersea", pegs: [Color.blue, .purple, .teal].map(\.hex)),
        Theme(name: "Faces", pegs: ["😀", "😂", "😍", "😎", "🤔", "😡"]),
        Theme(name: "Vehicles", pegs: ["🚗", "🚌", "🚲", "🚁", "🚀", "🚂"]),
        Theme(name: "Animals", pegs: ["🐶", "🐱", "🦊", "🐼", "🐸", "🐵"]),
        Theme(name: "Food", pegs: ["🍎", "🍔", "🍣", "🍕", "🍩", "🍇"]),
        Theme(name: "Sports", pegs: ["⚽️", "🏀", "🏈", "🎾", "🏐", "🏓"])
    ]
    
    static let `default` = all.first!
    
    static func random() -> Theme {
        all.randomElement() ?? .default
    }
    
    static func named(_ name: String) -> Theme? {
        all.first { $0.name == name }
    }
}
