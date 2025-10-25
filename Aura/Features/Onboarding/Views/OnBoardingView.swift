//
//  OnBoardingView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 25/10/2025.
//

import SwiftUI

struct OnBoardingView: View {
    @Environment(AppState.self) private var authState
    @State private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            viewModel.pages[viewModel.currentPage].backgroundColor
                .ignoresSafeArea()
            
            VStack {
                ProgressView(value: viewModel.progress)
                    .progressViewStyle(
                        LinearProgressViewStyle(tint: Color.black)
                    )
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .frame(width: 360)
                
                Spacer(minLength: 0)
                 
                TabView(selection: $viewModel.currentPage) {
                    ForEach(viewModel.pages) { page in
                        OnboardingPageView(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentPage)
                
                Spacer(minLength: 0)
                
                Button(action: {
                    if viewModel.isLastPage {
                        authState.isOnboardingNeeded = false
                    } else {
                        withAnimation {
                            viewModel.nextPage()
                        }
                    }
                }) {
                    Text(viewModel.isLastPage ? "Commencer" : "Suivant")
                        .frame(width: 150, height: 55)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .font(.custom("Lexend-Bold", size: 17))
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Image(page.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
                    .padding(.top, geometry.size.height * 0.25)
                
                Text(page.title)
                    .font(.custom("Lexend-Medium", size: 27))
                
                Text(page.description)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .font(.system(size: 17))
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    OnBoardingView()
        .environment(AppState())
}
