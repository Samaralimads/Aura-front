//
//  DashboardView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI

struct DashboardView: View {
    @State private var viewModel = ProfileViewModel()
    var body: some View {
        VStack(alignment: .leading){
            Text("Salut \(viewModel.userName),")
                .font(.custom("Lexend-Medium", size: 27))
                .padding(.bottom, 20)
                .padding(.top, 10)
            
           challengeView()
            
            //MEDITATION
            HStack{
                NavigationLink{
                    PickerView(currentSelection: 0)
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 178, height: 230)
                            .cornerRadius(20)
                            .foregroundColor(.jauneClair)
                        VStack{
                            Text("Meditation")
                                .font(.custom("Lexend-Medium", size: 22))
                                .padding(.bottom, 2)
                                .foregroundColor(.black)
                            Text("Des sessions pour apaiser ton esprit")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 5)
                            Image("meditation")
                                .resizable()
                                .frame(width: 140, height: 111)
                        }
                    }
                }

                //RESPIRATION
                NavigationLink{
                    PickerView(currentSelection: 1)
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 178, height: 230)
                            .cornerRadius(20)
                            .foregroundColor(.vertClair)
                        VStack{
                            Text("Respiration")
                                .font(.custom("Lexend-Medium", size: 22))
                                .foregroundColor(.black)
                                .padding(.bottom, 2)
                            Text("Un souffle après l’autre")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 5)
                            Image("respiration")
                                .resizable()
                                .frame(width: 86, height: 116)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 17)
    }
}


#Preview {
    DashboardView()
}
