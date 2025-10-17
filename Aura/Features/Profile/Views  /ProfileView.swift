//
//  ProfileView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI


struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.userName)")
                .font(.custom("Lexend-Bold", size: 36))
                .padding()
            Spacer()
        }
    }
}


#Preview {
    ProfileView()
}
