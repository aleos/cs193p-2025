//
//  CodeWordBreakerApp.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 18/2/2026.
//

import SwiftData
import SwiftUI

@main
struct CodeWordBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: CodeWordBreaker.self)
        }
    }
}
