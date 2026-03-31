//
//  Settings.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 31/3/2026.
//

import SwiftUI

struct Settings: View {
    // MARK: Data In
    @Environment(\.settings) var settings
    
    // MARK: Data Shared with Me
    @Binding var isPresented: Bool
    
    var body: some View {
        @Bindable var settings = settings
        NavigationStack {
            Form {
                Picker(selection: $settings.defaultWordLength) {
                    ForEach(3...6, id: \.self) { defaultWordLength in
                        Text("\(defaultWordLength)")
                            .tag(defaultWordLength)
                    }
                } label: {
                    Label("Default word length", systemImage: "number")
                }
                ColorPicker("Exact color", selection: $settings.exactMatchColor)
                ColorPicker("Inexact color", selection: $settings.inexactMatchColor)
                ColorPicker("No match color", selection: $settings.noMatchColor)
            }
            .toolbar {
                Button("Done") { isPresented = false }
            }
            .navigationTitle("Settings")
        }
    }
}
