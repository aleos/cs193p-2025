//
//  AppSettings.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 31/3/2026.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var settings: AppSettings = .shared
}

@MainActor
@Observable
final class AppSettings {
    static let shared = AppSettings()
    
    var defaultWordLength: Int = CodeWordBreaker.defaultNumberOfLetters {
        didSet { UserDefaults.standard.set(defaultWordLength, forKey: Key.defaultWordLength.rawValue) }
    }
    var exactMatchColor: Color {
        didSet { UserDefaults.standard.set(exactMatchColor.hex, forKey: Key.exactMatchColor.rawValue) }
    }
    var inexactMatchColor: Color {
        didSet { UserDefaults.standard.set(inexactMatchColor.hex, forKey: Key.inexactMatchColor.rawValue) }
    }
    var noMatchColor: Color {
        didSet { UserDefaults.standard.set(noMatchColor.hex, forKey: Key.noMatchColor.rawValue) }
    }
    
    func color(for match: Code.Match) -> Color {
        switch match {
        case .exact: exactMatchColor
        case .inexact: inexactMatchColor
        case .nomatch: noMatchColor
        }
    }
    
    init() {
        let defaultWordLength = UserDefaults.standard.integer(forKey: Key.defaultWordLength.rawValue)
        self.defaultWordLength = defaultWordLength > 0 ? defaultWordLength : CodeWordBreaker.defaultNumberOfLetters
        self.exactMatchColor = UserDefaults.standard.string(forKey: Key.exactMatchColor.rawValue).flatMap(Color.init(hex:)) ?? .green
        self.inexactMatchColor = UserDefaults.standard.string(forKey: Key.inexactMatchColor.rawValue).flatMap(Color.init(hex:)) ?? .yellow
        self.noMatchColor = UserDefaults.standard.string(forKey: Key.noMatchColor.rawValue).flatMap(Color.init(hex:)) ?? .gray
    }
    
    private enum Key: String {
        case defaultWordLength
        case exactMatchColor
        case inexactMatchColor
        case noMatchColor
    }
}
