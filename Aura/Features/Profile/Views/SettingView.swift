//
//  SettingView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 22/10/2025.
//
import SwiftUI

struct SettingView: View {
    @Bindable var viewModel: SettingViewModel
    @State private var password: String = ""
    
    init(profileViewModel: ProfileViewModel) {
        self.viewModel = SettingViewModel(profileViewModel: profileViewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Avatar
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
            
            // Bouton pour modifier l'avatar
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
            
            // Formulaire
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
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            Spacer()
            
            // Bouton de sauvegarde
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Réglages")
                    .font(.custom("Lexend-Medium", size: 27))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
    NavigationStack {
        SettingView(profileViewModel: ProfileViewModel())
    }
}
