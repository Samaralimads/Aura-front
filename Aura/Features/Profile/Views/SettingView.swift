//
//  SettingView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 22/10/2025.
//

import SwiftUI

struct SettingView: View {
    @State private var firstName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Image("perso-violet")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 112, height: 112)
                    .padding(.top, 20)
                    
                // Bouton "Modifier mon avatar"
                Button(action: {
                    print("Modifier mon avatar")
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
                    
                // Conteneur pour les champs et le bouton "Supprimer"
                VStack(spacing: 16) {
                    fieldWithLabel(
                        label: "Prénom",
                        placeholder: "Saisir votre prénom",
                        text: $firstName
                    )
                    .textContentType(.givenName)
                    .autocapitalization(.words)
                        
                    fieldWithLabel(
                        label: "Email",
                        placeholder: "Saisir votre email",
                        text: $email
                    )
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                        
                    fieldWithLabel(
                        label: "Mot de passe",
                        placeholder: "Saisir votre mot de passe",
                        text: $password,
                        isSecure: true
                    )
                    .textContentType(.password)
                        
                    HStack {
                        Button(action: {
                            print("Supprimer mon compte")
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
            }
            
            Spacer()
            
            Button(action: {
                print("Sauvegarder les modifications")
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
                            .cornerRadius(25)
                    )
            } else {
                TextField(placeholder, text: text)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                            .cornerRadius(25)
                    )
            }
        }
        .padding(.leading, 4)
    }
}


#Preview {
    SettingView()
}
