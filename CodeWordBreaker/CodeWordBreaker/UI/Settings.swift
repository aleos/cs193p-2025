//
//  Settings.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 31/3/2026.
//

import SwiftUI

struct Settings: View {
    // MARK: Data In
    @Environment(\.settings) private var settings
    
    // MARK: Data Shared with Me
    @Binding var isPresented: Bool
    
    // MARK: - Body
    
    var body: some View {
        @Bindable var settings = settings
        NavigationStack {
            Form {
                Section("Words") {
                    Picker(selection: $settings.defaultWordLength) {
                        ForEach(3...6, id: \.self) { defaultWordLength in
                            Text("\(defaultWordLength)")
                                .tag(defaultWordLength)
                        }
                    } label: {
                        Label("Default word length", systemImage: "number")
                    }
                }
                Section("Match colours") {
                    ColorPicker("Exact", selection: $settings.exactMatchColor)
                    ColorPicker("Inexact", selection: $settings.inexactMatchColor)
                    ColorPicker("No match", selection: $settings.noMatchColor)
                }
            }
            .toolbar {
                Button("Done") { isPresented = false }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    Settings(isPresented: $isPresented)
}
