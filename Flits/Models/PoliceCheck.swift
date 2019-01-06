//
//  PoliceCheck.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation

class PoliceCheck: Item {
    
    // MARK: Properties
    let location: String
    let descriptionText: String?
    var imagePath: String?
    let userID: String
    var likes: Set<String>
    var dislikes: Set<String>
    let timeCreated: Date
    let expireDate: Date
    
    // MARK: - Constructors
    init(location: String, descriptionText: String? = nil, imagePath: String? = nil) {
        self.timeCreated = Date()
        self.location = location
        self.descriptionText = descriptionText
        self.imagePath = imagePath
        self.userID = Auth.auth().currentUser!.uid
        self.likes = []
        self.dislikes = []
        self.expireDate = Date(timeInterval: 21600, since: timeCreated)
    }
    
    // MARK: Functions
    func getLikes() -> Int {
        return likes.count
    }
    
    func getDislikes() -> Int {
        return dislikes.count
    }
    
    func like(userId: String) {
        removeLike(userId: userId)
        likes.insert(userId)
    }
    
    func dislike(userId: String) {
        removeLike(userId: userId)
        dislikes.insert(userId)
    }
    
    func removeLike(userId: String) {
        likes.remove(userId)
        dislikes.remove(userId)
    }
    }
    
    func removeLike(userUid: String) {
        likes.remove(userUid)
        dislikes.remove(userUid)
    }
    
}
