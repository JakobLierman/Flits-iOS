//
//  AvgSpeedCheck.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation
import ObjectMapper

class AvgSpeedCheck: Item, ImmutableMappable {
    
    // MARK: - Properties
    let beginLocation: String
    let endLocation: String
    let userID: String
    var likes: Set<String>
    var dislikes: Set<String>
    let timeCreated: Date
    
    // MARK: - Constructors
    init(beginLocation: String, endLocation: String) {
        self.timeCreated = Date()
        self.beginLocation = beginLocation
        self.userID = Auth.auth().currentUser!.uid
        self.likes = []
        self.dislikes = []
        self.endLocation = endLocation
    }
    
    // MARK: - ObjectMapper
    required init(map: Map) throws {
        beginLocation   = try map.value("beginLocation")
        endLocation     = try map.value("endLocation")
        userID          = try map.value("user")
        likes           = (try? map.value("likes")) ?? []
        dislikes        = (try? map.value("dislikes")) ?? []
        timeCreated     = try map.value("timeCreated", using:DateTransform())
    }
    
    func mapping(map: Map) {
        beginLocation   >>> map["beginLocation"]
        endLocation     >>> map["endLocation"]
        userID          >>> map["user"]
        timeCreated     >>> (map["timeCreated"], DateTransform())
    }
    
    // MARK: - Functions
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
    
    func removeLike(userUid: String) {
        likes.remove(userUid)
        dislikes.remove(userUid)
    }

}
