//
//  LoginView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 10/10/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Image("bien")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.top, 60)
                .padding(.bottom, 20)
            

            VStack(spacing: 8) {
                Text("Bon retour !")
                    .font(.custom("Lexend-Bold", size: 36))
                    .bold()
                Text("Connectez-vous")
                    .font(.custom("Lexend-Bold", size: 36))
            }
            .foregroundColor(.primary)
            
            VStack(spacing: 16) {

                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(.white))
                        .frame(height: 56)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .bold()
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.horizontal, 16)
                }
                .frame(width: 360, height: 56)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(.white))
                        .frame(height: 56)
                    
                    SecureField("Mot de passe", text: $password)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .textContentType(.password)
                        .padding(.horizontal, 16)
                        .bold()
                }
                .frame(width: 360, height: 56)
            }
            .padding(.top, 40)
            
            HStack {
                Spacer()
                Button(action: {
                    print("Mot de passe oublié ?")
                }) {
                    Text("Mot de passe oublié ?")
                        .font(.caption)
                        .foregroundColor(.black)
                        
                }
                Spacer()
            }
            .padding(.top, 8)
            
            Button(action: {
                print("Se connecter")
            }) {
                Text("Se connecter")
                    .font(.custom("Lexend-Bold", size: 22))
                    .foregroundColor(.white)
                    .frame(width: 360, height: 56)
                    .background(Color.black)
                    .cornerRadius(25)
            }
            .padding(.top, 20)
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("Vous n’avez pas de compte ?")
                    .font(.custom("Lexend-Medium", size: 17))
                    .foregroundColor(.primary)
                
                NavigationLink(destination: RegisterView()) {
                    Text("Créer un compte")
                        .font(.custom("Lexend-Bold", size: 17))
                        .foregroundColor(.black)
                }
            }
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("jaune-clair"))
    }
}

// Navigation
struct RegisterView: View {
    var body: some View {
        Text("Page d'inscription")
            .navigationTitle("Créer un compte")
    }
}


#Preview {
    NavigationStack {
        LoginView()
    }
}
