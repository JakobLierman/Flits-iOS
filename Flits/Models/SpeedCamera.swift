//
//  SpeedCamera.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation

class SpeedCamera: Item {

    // MARK: Properties
    let location: String
    let kind: String
    var descriptionText: String?
    var imagePath: String?
    let userID: String
    var likes: Set<String>
    var dislikes: Set<String>
    let timeCreated: Date
    var expireDate: Date?

    // MARK: - Constructors
    init(location: String, kind: String, descriptionText: String? = nil, imagePath: String? = nil) {
        self.timeCreated = Date()
        self.location = location
        self.kind = kind
        self.descriptionText = descriptionText
        self.imagePath = imagePath
        self.userID = Auth.auth().currentUser!.uid
        self.likes = []
        self.dislikes = []
        self.expireDate = calculateExpireDate()
    }

    // MARK: Functions
    private func calculateExpireDate() -> Date? {
        let expireDate: Date?
        switch kind {
        case "Vaste flitspaal":
            expireDate = nil
        case "Flitsauto":
            expireDate = Date(timeInterval: 21600, since: timeCreated)
        case "Lidar (superflitspaal)":
            expireDate = Date(timeInterval: 43200, since: timeCreated)
        default:
            expireDate = Date(timeInterval: 604800, since: timeCreated)
        }
        return expireDate
    }
    
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
