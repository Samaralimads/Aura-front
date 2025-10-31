//
//  Player1Model.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct Wave : Shape {
    var amplitude: CGFloat //hauteur de la vague
    var frequency: CGFloat //nombre de vagues sur la largeur
    var phase: CGFloat //animation : décalage horizontal de l’onde
    
    //Pour rendre phase animable
      var animatableData: CGFloat {
          get { phase }
          set { phase = newValue }
      }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height / 2
        
        path.move(to: CGPoint(x: 0, y: height))
        
        for x in stride(from: 0, through: width, by: 1){
            let relativeX = CGFloat(x) / width
            let sine = sin((relativeX * frequency * 2 * .pi) + phase)
            
            //Applique une variation d’amplitude
            let variation = amplitude * (1 + 0.3 * cos(relativeX * 4 * .pi))
            let y = height + sine * variation
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        // Fermer le path pour remplir sous la vague
        path.addLine(to: CGPoint(x: width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}
