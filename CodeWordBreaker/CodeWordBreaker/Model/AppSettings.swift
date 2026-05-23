//
//  AppSettings.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 31/3/2026.
//

import SwiftData
import SwiftUI

extension EnvironmentValues {
    @Entry var settings: AppSettings = .shared
}

@Model
final class AppSettings {
    static let shared = AppSettings()
        
    var defaultWordLength: Int = CodeWordBreaker.defaultNumberOfLetters
    private var exactMatchHex = Color.green.hex
    var exactMatchColor: Color {
        get { Color(hex: exactMatchHex) ?? .green }
        set { exactMatchHex = newValue.hex }
    }
    private var inexactMatchHex = Color.yellow.hex
    var inexactMatchColor: Color {
        get { Color(hex: inexactMatchHex) ?? .yellow }
        set { inexactMatchHex = newValue.hex }
    }
    private var noMatchHex = Color.gray.hex
    var noMatchColor: Color {
        get { Color(hex: noMatchHex) ?? .gray }
        set { noMatchHex = newValue.hex }
    }
    
    func color(for match: Code.Match) -> Color {
        switch match {
        case .exact: exactMatchColor
        case .inexact: inexactMatchColor
        case .nomatch: noMatchColor
        }
    }
    
    init() {}
}
