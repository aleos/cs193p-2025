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

@Observable
final class AppSettings {
    static let shared = AppSettings()
    
    var defaultWordLength: Int = CodeWordBreaker.defaultNumberOfLetters
    var exactMatchColor: Color = .green
    var inexactMatchColor: Color = .yellow
    var noMatchColor: Color = .gray
    
    func color(for match: Match) -> Color {
        switch match {
        case .exact: exactMatchColor
        case .inexact: inexactMatchColor
        case .nomatch: noMatchColor
        }
    }
}
