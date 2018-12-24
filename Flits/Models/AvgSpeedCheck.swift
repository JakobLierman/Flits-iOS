//
//  AvgSpeedCheck.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation

class AvgSpeedCheck: Item {
    
    // MARK: Properties
    let beginLocation: String
    let endLocation: String
    var likes: Set<String>
    var dislikes: Set<String>
    let timeCreated: Date
    
    // MARK: Constructors
    init(beginLocation: String, endLocation: String) {
        self.timeCreated = Date()
        self.beginLocation = beginLocation
        self.likes = []
        self.dislikes = []
        self.endLocation = endLocation
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
