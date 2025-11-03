//
//  ProfileView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//
import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var viewModel: ProfileViewModel
    @State private var badgeViewModel = BadgeViewModel()
    @State private var navigateToLogin = false
    @State private var isDarkModeOn = false
    @State private var isNotification = false
    @State private var showNotificationAlert = false
    @State private var notificationAlertMessage = ""
    
    private let authState: AppState
    
    init(authState: AppState) {
        self.authState = authState
        _viewModel = State(initialValue: ProfileViewModel(authState: authState))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                Text(viewModel.userName)
                    .font(.custom("Lexend-Bold", size: 27))
                    .padding(.top, 20)
                
                AsyncImage(url: URL(string: viewModel.avatarURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .frame(width: 112, height: 112)
                .clipShape(Circle())
                
                HStack {
                    Text("Mes badges")
                        .font(.custom("Lexend-Bold", size: 22))
                    Spacer()
                    NavigationLink(destination: BadgeView(viewModel: BadgeViewModel())) {
                        Text("Tout voir")
                            .font(.custom("Lexend-Regular", size: 16))
                            .underline()
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 5)
                .padding(.top, 20)
                
                // Badges preview
                HStack(spacing: 15) {
                    if badgeViewModel.unlockedBadges.isEmpty {
                        Text("Pas de badges")
                            .font(.custom("Lexend-Bold", size: 18))
                            .foregroundColor(.gray)
                    } else {
                        ForEach(badgeViewModel.unlockedBadges.prefix(3), id: \.id) { badge in
                            AutonomeBadge(badge: badge, isLocked: false)
                        }
                    }
                }
                .task {
                    await badgeViewModel.fetchUserBadges()
                }
                .frame(height: 110)
                
                // Settings section
                VStack(spacing: 16) {
                    HStack {
                        Text("Notification")
                            .foregroundColor(.black)
                        Spacer()
                        Toggle("", isOn: $isNotification)
                            .tint(.violet)
                            .onChange(of: isNotification) {
                                notificationAlertMessage = isNotification ? " Notification Activées" : "Notification Désactivées"
                                showNotificationAlert = true
                            }
                    }
                    HStack {
                        Text("Dark mode")
                            .foregroundColor(.black)
                        Spacer()
                        Toggle("", isOn: $isDarkModeOn)
                            .tint(.violet)
                            .onChange(of: isDarkModeOn) {
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                    windowScene.windows.first?.overrideUserInterfaceStyle = isDarkModeOn ? .dark : .light
                                }
                            }
                    }
                    NavigationLink(destination: FAQView()) {
                        HStack {
                            Text("FAQs")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(
                        destination: SettingView(profileViewModel: viewModel)
                    ) {
                        HStack {
                            Text("Réglages")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: TechnicalSupportView()) {
                        HStack {
                            Text("Support technique")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.grisClair)
                .cornerRadius(20)
                .padding(.top, 15)
                
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
                            .font(.custom("Lexend-Medium", size: 17))
                            .frame(width: 360, height: 50)
                            .background(Color.violet)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
        .alert("", isPresented: $showNotificationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(notificationAlertMessage)
        }
    }
}


#Preview {
    ProfileView(authState: AppState())
}
