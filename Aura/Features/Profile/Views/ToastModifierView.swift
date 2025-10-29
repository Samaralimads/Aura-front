//
//  ToastModifierView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 28/10/2025.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @ObservedObject var viewModel: ToastViewModel
    
    func body(content: Content) -> some View {
        ZStack(alignment: viewModel.alignment) {
            content
            if viewModel.isShowing {
                HStack(spacing: 8) {
                    if let systemImage = viewModel.systemImage {
                        Image(systemName: systemImage)
                            .foregroundColor(
                                viewModel.systemImage == "checkmark.circle.fill" ? .green : .red
                            )
                    }
                    Text(viewModel.message)
                        .font(.custom("Lexend-Regular", size: 14))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(viewModel.alignment == .bottom ? .bottom : .top, 80)
                .transition(
                    .opacity
                        .combined(
                            with: .move(edge: viewModel.alignment == .bottom ? .bottom : .top)
                        )
                )
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: viewModel.isShowing)
    }
}

extension View {
    func showToast(viewModel: ToastViewModel) -> some View {
        self.modifier(ToastModifier(viewModel: viewModel))
    }
}
