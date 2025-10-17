//
//  ProfileView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI


struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                
                Text("\(viewModel.userName)")
                    .font(.custom("Lexend-Bold", size: 36))
                    .padding()
                
                Image("perso-violet")
                    .scaledToFit()
                    .frame(width: 112, height: 112)

                HStack {
                    Text("Mes badges")
                        .font(.custom("Lexend-Bold", size: 22))
                    
                    Spacer()
                    
                    NavigationLink(destination: BadgeView()) {
                        Text("Tout voir")
                            .font(.custom("Lexend-Regular", size: 16))
                            .underline()
                            .foregroundStyle(.black)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button(action: {
                        Task {
                            await viewModel.logout()
                            navigateToLogin = true
                        }
                    }) {
                        Text("Se déconnecter")
                            .font(.custom("Lexend-Regular", size: 17))
                            .frame(width: 350, height: 30)
                            .padding()
                            .background(Color.violet)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .bold()
                    }
                    .padding()
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
    }
}


#Preview {
    ProfileView()
}
