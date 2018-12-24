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
    let description: String?
    var likes: Set<String>
    var dislikes: Set<String>
    let timeCreated: Date
    let expireDate: Date
    
    // MARK: Constructors
    init(location: String, details: String? = nil) {
        self.timeCreated = Date()
        self.location = location
        self.description = details
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
    
    func like(userUid: String) {
        // TODO
        // Check if user already liked
        // like
    }
    
    func dislike(userUid: String) {
        // TODO
        // Check if user already liked
        // dislike
    }
    
    func removeLike(userUid: String) {
        // TODO
        // Check if user already liked
        // remove (dis)like
    }
    
}
