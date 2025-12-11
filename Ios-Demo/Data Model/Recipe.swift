//
//  Recipe.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//
import Foundation
import FirebaseFirestore
import FirebaseDatabase

struct Recipe: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var description: String
    var imageURL: String?
    var author: String
    var likes: Int = 0
    var timestamp: Date = Date()

    // Not stored in Firestore
    var isLiked: Bool = false
    var comments: [Comment] = []
}

struct Comment: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    let text: String
    let author: String
    let timestamp: Date = Date()
}

struct User : Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    let email: String
    
}

