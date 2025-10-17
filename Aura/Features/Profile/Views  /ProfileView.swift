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
    @State private var isDarkModeOn = false
    @State private var isNotification = false

    
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
                
                HStack(spacing: 12) {
                    ForEach(0..<4, id: \.self) { _ in
                        Image("med3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .frame(width: 80, height: 110)
                    }
                }
                .frame(height: 110)
                .padding(.horizontal)
            }
            
            VStack(spacing: 16) {

                HStack {
                    Text("Notification")
                    Spacer()
                    Toggle("", isOn: $isNotification)
                        .tint(.violet)
                }
            
                HStack {
                    Text("Dark mode")
                    Spacer()
                    Toggle("", isOn: $isDarkModeOn)
                        .tint(.violet)
                }
            
                HStack {
                    Text("FAQs")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            
                HStack {
                    Text("Réglages")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            
                HStack {
                    Text("Support technique")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.grisClair)
            .cornerRadius(20)
            .frame(width: 360, height: 250)
            
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
                        .frame(width: 360, height: 30)
                        .padding()
                        .background(Color.violet)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .bold()
                }
                .padding()
                Spacer()
            }
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            LoginView()
        }
    }
}


#Preview {
    ProfileView()
}
