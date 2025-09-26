//
//  BreathingModelView.swift
//  Aura
//
//  Created by alize suchon on 25/09/2025.
//

import SwiftUI

//@Observable
//class Breathing: Identifiable, Decodable {
//    var id: UUID
//    var type: String
//    var duration: Int
//    var image: String
//    var title: String
//    var description: String
//    var indexOrder: Int
//    
//    init(id: UUID = UUID(), type: String, duration: Int, image: String, title: String, description: String, indexOrder: Int) {
//        self.id = id
//        self.type = type
//        self.duration = duration
//        self.image = image
//        self.title = title
//        self.description = description
//        self.indexOrder = indexOrder
//    }
//}


struct Breathing: Identifiable, Decodable {
    let id: UUID
    let type: String
    let duration: Int
    let image: String
    let title: String
    let description: String
    var animation: AnimationType? = nil 
}

enum AnimationType: String, Codable {
    case wave
    case montain
    case sun
    case moon
}
