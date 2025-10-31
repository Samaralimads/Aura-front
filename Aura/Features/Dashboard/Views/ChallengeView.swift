//
//  challengeView.swift
//  Aura
//
//  Created by alize suchon on 17/10/2025.
//

import SwiftUI

struct ChallengeView: View {
    
    @State var viewModel = ChallengeViewModel()
    @State var completedCount : Int = 0
    @State var completedTasks : [String : Bool] = [:]
    @State var finishedTask: Bool = false
    let authService = AuthService.shared
    
    
    var body: some View {
        ZStack (alignment: .topLeading){
            //FOND
            Rectangle()
                .foregroundColor(.violet)
                .cornerRadius(25)
                .frame(maxWidth: .infinity)
            
            if let challenge = viewModel.currentChallenge {
                
                VStack (alignment: .leading, spacing: 8){
                    Text(challenge.theme)
                        .font(.custom("Lexend-Medium", size: 24))
                        .foregroundColor(.white)
                    
                    HStack(alignment: .top){
                        
                        VStack (alignment: .leading, spacing: 14){
                            Text(challenge.description)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(completedCount)/\(viewModel.tasks.count)")
                                .foregroundColor(.white)
                                .font(.custom("Lexend-Medium", size: 17))
                                .frame(width: 60, height: 35)
                                .background(.black.opacity(0.3))
                                .cornerRadius(25)
                        }
                        VStack{
                            AsyncImage(url: URL(string:"http://127.0.0.1:8080/challenge/\(challenge.image)")) { image in
                                image
                                    .resizable()
                                    .frame(width: 160, height: 115)
                                    .padding(.top, -15)
                                    .padding(.bottom, 10)
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    //TACHES
                    ForEach(viewModel.tasks) { task in
                        ZStack(alignment: .leading){
                            Rectangle()
                                .frame(minHeight: 35)
                                .foregroundColor(.black.opacity(0.3))
                                .cornerRadius(50)
                            //TACHES
                            HStack(spacing: 20){
                                Button(action: {
                                    if completedTasks[task.title] == true {
                                        completedTasks[task.title] = false
                                        completedCount -= 1
                                    } else {
                                        completedTasks[task.title] = true
                                        completedCount += 1
                                        //FONCTION QUI REMPLI TABLE userTask
                                        Task {
                                            do {
                                                let id = try await authService.getUserID()
                                                if let userID = UUID(uuidString: id),
                                                   let taskID = task.id {
                                                    await viewModel.sendUserTask(
                                                        userID: userID,
                                                        taskID: taskID
                                                    )
                                                } else {
                                                    print("ID utilisateur invalide: \(id)")
                                                }
                                            } catch {
                                                print("Erreur lors de la récupération de l'ID utilisateur: \(error)")
                                            }
                                        }

                                    if completedCount == viewModel.tasks.count {
                                        finishedTask = true
                                        //FONCTION QUI REMPLI TABLE userChallenge
                                        Task {
                                            do {
                                                let id = try await authService.getUserID()
                                                if let userID = UUID(uuidString: id),
                                                let challengeID = viewModel.currentChallenge?.id{
                                                    await viewModel.sendUserChallenge(
                                                        userID: userID,
                                                        challengeID: challengeID)
                                                } else {
                                                    print("ID utilisateur invalide: \(id)")
                                                }
                                            } catch {
                                                print("Erreur ID utilisateur: \(error)")
                                            }
                                        }
                                    }
                                    }
                                }){
                                    if completedTasks[task.title] == true {
                                        Image(systemName:"checkmark.circle.fill")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .frame(width: 25, height: 25)
                                    } else {
                                        Circle()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.black.opacity(0.2))
                                    }
                                }
                                Text(task.title)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical,5)
                        }
                    }
                    
                    .alert("Félicitations !", isPresented: $finishedTask) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Vous avez terminé ce défi !")
                    }                }
                .padding(17)
            } else {
                VStack(alignment: .center) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Chargement...")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                .padding(25)
            }
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .task {
            await viewModel.fetchCurrentChallenge()
            
            if let challengeID = viewModel.currentChallenge?.id {
                await viewModel.fetchTasks(id: challengeID)
            } else {
                print("ERROR: No challenge found")
            }
        }
    }
}

#Preview {
    ChallengeView()
}
