//
//  SwiftDataPreview.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 11/4/2026.
//


import SwiftData
import SwiftUI

struct SwiftDataPreview: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: CodeWordBreaker.self, configurations: .init(isStoredInMemoryOnly: true))
//        [CodeWordBreaker].samples.forEach(container.mainContext.insert)
        return container
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
