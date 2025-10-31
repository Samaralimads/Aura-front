//
//  LoginView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 10/10/2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) private var authState
    @State private var viewModel: LoginViewModel
    
    init() {
        _viewModel = State(initialValue: LoginViewModel(authState: AppState()))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("bien")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text("Bon retour !")
                        .font(.custom("Lexend-Medium", size: 27))
                    Text("Connectez-vous")
                        .font(.custom("Lexend-Medium", size: 27))
                }
                .foregroundColor(.primary)
                
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(.white))
                            .frame(height: 56)
                        
                        TextField("Email", text: $viewModel.email)
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
                        
                        SecureField("Mot de passe", text: $viewModel.password)
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
                            .font(.custom("Lexend-Regular", size: 17))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                Button(action: {
                    Task { await viewModel.login() }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: .white)
                            )
                    } else {
                        Text("Se connecter")
                            .font(.custom("Lexend-Medium", size: 22))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 360, height: 56)
                .background(Color.black)
                .cornerRadius(25)
                .disabled(viewModel.isLoading)
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("jaune-clair"))
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            viewModel = LoginViewModel(authState: authState)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}


#Preview {
    LoginView()
        .environment(AppState())
}
