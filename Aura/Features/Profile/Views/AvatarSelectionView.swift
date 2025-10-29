//
//  AvatarSelectionView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 24/10/2025.
//

import SwiftUI

struct AvatarSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SettingViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Grid(horizontalSpacing: 16, verticalSpacing: 20) {
                    GridRow {
                        ForEach(viewModel.avatars.prefix(3)) { avatar in
                            AvatarButton(avatar: avatar, viewModel: viewModel)
                        }
                    }
                    GridRow {
                        ForEach(viewModel.avatars.dropFirst(3)) { avatar in
                            AvatarButton(avatar: avatar, viewModel: viewModel)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    if let selectedAvatar = viewModel.selectedAvatarURL {
                        let avatarWithPath = "avatars/\(selectedAvatar)"
                        Task {
                            await viewModel.updateUserProfile(
                                firstName: viewModel.firstName,
                                email: viewModel.email,
                                password: nil,
                                avatar: avatarWithPath
                            )
                            dismiss()
                        }
                    }
                }) {
                    Text("Valider")
                        .font(.custom("Lexend-SemiBold", size: 17))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(
                            viewModel.selectedAvatarURL != nil ? Color.violet : Color.gray
                        )
                        .cornerRadius(25)
                }
                .disabled(viewModel.selectedAvatarURL == nil)
                .padding(.bottom, 30)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Choisir un avatar")
                        .font(.custom("Lexend-Medium", size: 18))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadAvatars()
            }
        }
    }
    
    @ViewBuilder
    private func AvatarButton(avatar: Avatar, viewModel: SettingViewModel) -> some View {
        Button(action: {
            viewModel.selectedAvatarURL = avatar.url
        }) {
            VStack {
                if let url = viewModel.getAvatarImageURL(avatar.url) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        viewModel.selectedAvatarURL == avatar.url ? Color.violet : Color.clear,
                        lineWidth: 3
                    )
            )
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    let appState = AppState()
    
    let profileViewModel = ProfileViewModel(authState: appState)
    
    let viewModel = SettingViewModel(profileViewModel: profileViewModel)
    
    viewModel.avatars = [
        Avatar(id: 1, url: "https://example.com/avatar1.png"),
        Avatar(id: 2, url: "https://example.com/avatar2.png"),
        Avatar(id: 3, url: "https://example.com/avatar3.png"),
        Avatar(id: 4, url: "https://example.com/avatar4.png"),
        Avatar(id: 5, url: "https://example.com/avatar5.png"),
        Avatar(id: 6, url: "https://example.com/avatar6.png")
    ]
    viewModel.selectedAvatarURL = viewModel.avatars[0].url
    
    return AvatarSelectionView(viewModel: viewModel)
        .environment(appState)
}
