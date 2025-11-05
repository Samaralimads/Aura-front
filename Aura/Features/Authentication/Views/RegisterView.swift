//
//  RegisterView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 16/10/2025.
//

import SwiftUI

struct RegisterView: View {
    @Environment(AppState.self) private var authState
    @State private var viewModel: RegisterViewModel
    @State private var showErrorAlert = false
    
    init() {
        _viewModel = State(
            initialValue: RegisterViewModel(authState: AppState())
        )
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
                    Text("C'est parti !")
                        .font(.custom("Lexend-Medium", size: 27))
                }
                .foregroundColor(.primary)
                
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(.white))
                            .frame(height: 56)
                        
                        TextField("Prénom", text: $viewModel.firstName)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .bold()
                            .autocapitalization(.none)
                            .padding(.horizontal, 16)
                    }
                    .frame(width: 360, height: 56)
                    
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
                .padding(.top, 20)
                
                if let errorMessage = viewModel.errorMessage, showErrorAlert {
                    FeedbackView(message: errorMessage, isError: true)
                }
                
                Button(action: {
                    Task {
                        await viewModel.register()
                        if viewModel.errorMessage != nil {
                            showErrorAlert = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showErrorAlert = false
                            }
                        }
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: .white)
                            )
                    } else {
                        Text("Créer un compte")
                            .font(.custom("Lexend-Medium", size: 22))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 360, height: 56)
                .background(Color.black)
                .cornerRadius(25)
                .disabled(viewModel.isLoading)
                .padding(.top, 50)
                .padding(.bottom, 20)
                
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 75, height: 1)
                    
                    Text("Créer un compte avec ")
                        .font(.custom("Lexend-Medium", size: 17))
                        .foregroundColor(.primary)
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 75, height: 1)
                }
                .padding(.bottom, 5)
                
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image("ButtonFacebook")
                            .frame(width: 105, height: 50)
                        
                        Image("ButtonGoogle")
                            .frame(width: 105, height: 50)
                        
                        Image("ButtonApple")
                            .frame(width: 105, height: 50)
                    }
                    .padding(.bottom, 30)
                    
                    Spacer()
                    
                    NavigationLink(destination: LoginView()) {
                        VStack(spacing: 4) {
                            Text("Avez-vous un compte ?")
                                .font(.custom("Lexend-Medium", size: 17))
                                .foregroundColor(.primary)
                            Text("Se connecter")
                                .font(.custom("Lexend-Bold", size: 17))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("jaune-clair"))
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            viewModel = RegisterViewModel(authState: authState)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    RegisterView()
        .environment(AppState())
}
