//
//  FeedbackView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 04/11/2025.
//

import SwiftUI

struct FeedbackView: View {
    let message: String
    let isError: Bool
    
    var body: some View {
        Text(message)
            .padding()
            .frame(height: 30)
            .background(isError ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top, 10)
    }
}

#Preview {
    FeedbackView(message: "Ceci est un message de feedback", isError: true)
}
