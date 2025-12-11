//
//  Recipe.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import Foundation

struct Recipe: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var imageURL: String?
    var author: String
    var authorPhotoURL: String? // Optional
    var likes: Int
    var isLiked: Bool = false
    var comments: [Comment] = []
}

struct Comment: Identifiable {
    let id = UUID()
    let text: String
    let author: String
    let timestamp: Date = Date()
}
