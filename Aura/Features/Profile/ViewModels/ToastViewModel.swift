//
//  ToastViewModel.swift
//  Aura
//
//  Created by Mehdi Legoullon on 28/10/2025.
//

import SwiftUI

@MainActor
class ToastViewModel: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var message: String = ""
    @Published var systemImage: String?
    @Published var alignment: Alignment = .bottom
    private let duration: Double
    
    init(
        duration: Double = 2.0,
        systemImage: String? = "checkmark.circle.fill",
        alignment: Alignment = .bottom
    ) {
        self.duration = duration
        self.systemImage = systemImage
        self.alignment = alignment
    }
    
    func showToast(
        message: String,
        systemImage: String? = nil,
        alignment: Alignment = .bottom
    ) {
        self.message = message
        self.systemImage = systemImage ?? self.systemImage
        self.alignment = alignment
        self.isShowing = true
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(duration))
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isShowing = false
            }
        }
    }
}
