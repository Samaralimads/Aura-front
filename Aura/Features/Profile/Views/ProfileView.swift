//
//  ProfileView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI


struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var badgeViewModel = BadgeViewModel()
    @State private var navigateToLogin = false
    @State private var isDarkModeOn = false
    @State private var isNotification = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("\(viewModel.userName)")
                    .font(.custom("Lexend-Bold", size: 36))
                
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
                
                HStack(spacing: 15) {
                    ForEach(
                        badgeViewModel.unlockedBadges.prefix(3),
                        id: \.id
                    ) { badge in
                        VStack {
                            if let url = badgeViewModel.getBadgeImageURL(
                                badge.image
                            ) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 110, height: 110)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(height: 110)
                
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
            .task {
                await badgeViewModel.fetchUserBadges()
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
