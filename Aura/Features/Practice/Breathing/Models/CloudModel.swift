//
//  cloundsModel.swift
//  Aura
//
//  Created by alize suchon on 10/10/2025.
//

import SwiftUI

struct Cloud : Identifiable {
    let id = UUID()
    var width : Double
    var height: Double
    var x: CGFloat
    var y: CGFloat
}

//@Observable
//class Cloud {
//    let id = UUID()
//    var width: Double
//    var height: Double
//    var x: CGFloat
//    var y: CGFloat
//    
//    init(width: Double, height: Double, x: CGFloat, y: CGFloat){
//        self.width = width
//        self.height = height
//        self.x = x
//        self.y = y
//    }
    
//    func moveToX(x: CGFloat) {
//           self.x = x
//       }
//}
