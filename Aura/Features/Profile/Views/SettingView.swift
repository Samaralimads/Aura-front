//
//  SettingView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 22/10/2025.
//

import SwiftUI

struct SettingView: View {
    @Environment(AppState.self) private var authState
    @Bindable var viewModel: SettingViewModel
    @State private var password: String = ""
    @State private var showDeleteConfirmation = false
    
    init(profileViewModel: ProfileViewModel) {
        self.viewModel = SettingViewModel(profileViewModel: profileViewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let avatarURL = URL(string: viewModel.avatarURL) {
                    AsyncImage(url: avatarURL) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFit()
                    .frame(width: 112, height: 112)
                    .padding(.top, 20)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 112, height: 112)
                        .padding(.top, 20)
                }
                
                Button(action: {
                    viewModel.showAvatarSelection = true
                }) {
                    Text("Modifier mon avatar")
                        .font(.custom("Lexend-Regular", size: 17))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.black)
                .background(
                    Rectangle()
                        .fill(Color(.systemBackground))
                        .cornerRadius(0)
                )
                .sheet(isPresented: $viewModel.showAvatarSelection) {
                    AvatarSelectionView(viewModel: viewModel)
                        .presentationDetents([.medium, .large])
                }
                
                VStack(spacing: 16) {
                    fieldWithLabel(
                        label: "Prénom",
                        placeholder: "Saisir votre prénom",
                        text: $viewModel.firstName
                    )
                    .textContentType(.givenName)
                    .autocapitalization(.words)
                    
                    fieldWithLabel(
                        label: "Email",
                        placeholder: "Saisir votre email",
                        text: $viewModel.email
                    )
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    
                    fieldWithLabel(
                        label: "Mot de passe",
                        placeholder: "Nouveau mot de passe",
                        text: $password,
                        isSecure: true
                    )
                    .textContentType(.newPassword)
                    
                    HStack {
                        Button(action: {
                            showDeleteConfirmation = true
                        }) {
                            Text("Supprimer mon compte ?")
                                .font(.custom("Lexend-Regular", size: 17))
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, -4)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                Spacer()
                
                Button(action: {
                    Task {
                        await viewModel.updateUserProfile(
                            firstName: viewModel.firstName,
                            email: viewModel.email,
                            password: password.isEmpty ? nil : password
                        )
                    }
                }) {
                    Text("Sauvegarder")
                        .font(.custom("Lexend-SemiBold", size: 17))
                        .foregroundColor(.white)
                        .frame(width: 360, height: 50)
                        .background(Color.violet)
                        .cornerRadius(25)
                }
                .padding(.bottom, 20)
            }
            .alert(
                "Supprimer le compte",
                isPresented: $showDeleteConfirmation
            ) {
                Button("Confirmer", role: .destructive) {
                    Task {
                        await viewModel.deleteAccount()
                    }
                }
                Button("Annuler", role: .cancel) {}
            } message: {
                Text(
                    "Cette action est irréversible. Tous vos données seront supprimées."
                )
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Réglages")
                        .font(.custom("Lexend-Medium", size: 27))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(
                isPresented: $viewModel.shouldNavigateToLogin
            ) {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    @ViewBuilder
    private func fieldWithLabel(label: String, placeholder: String, text: Binding<String>, isSecure: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.custom("Lexend-Regular", size: 17))
                .foregroundColor(.black)
                .padding(.leading, 4)
            
            if isSecure {
                SecureField(placeholder, text: text)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )
            } else {
                TextField(placeholder, text: text)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )
            }
        }
        .padding(.leading, 4)
    }
}


#Preview {
    let appState = AppState()
    let profileViewModel = ProfileViewModel(authState: appState)
    NavigationStack {
        SettingView(profileViewModel: profileViewModel)
            .environment(appState)
    }
}
