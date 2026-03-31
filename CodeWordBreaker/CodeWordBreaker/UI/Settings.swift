//
//  Settings.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 31/3/2026.
//

import SwiftUI

struct Settings: View {
    @Binding var isPresented: Bool
    @Binding var defaultWordLength: Int
    
    var body: some View {
        NavigationStack {
            Form {
                Picker(selection: $defaultWordLength) {
                    ForEach(3...6, id: \.self) { defaultWordLength in
                        Text("\(defaultWordLength)")
                            .tag(defaultWordLength)
                    }
                } label: {
                    Label("Default word length", systemImage: "number")
                }
            }
            .toolbar {
                Button("Done") { isPresented = false }
            }
            .navigationTitle("Settings")
        }
    }
}
