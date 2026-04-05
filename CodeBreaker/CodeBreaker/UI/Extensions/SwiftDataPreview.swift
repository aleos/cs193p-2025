//
//  SwiftDataPreview.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 5/4/2026.
//

import SwiftData
import SwiftUI

struct SwiftDataPreview: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        try ModelContainer(for: CodeBreaker.self, configurations: .init(isStoredInMemoryOnly: true))
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait<Preview.ViewTraits> {
    @MainActor static var swiftData: Self = .modifier(SwiftDataPreview())
}

#Preview(traits: .modifier(SwiftDataPreview())) {
    Text("Hello, World!")
}
