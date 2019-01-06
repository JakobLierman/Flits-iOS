//
//  SpeedCamera.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class SpeedCamera: Item, ImmutableMappable, Hashable {
    
    // MARK: Properties
    var id: String = ""
    let location: String
    let kind: String
    var descriptionText: String?
    var imagePath: String?
    let userID: String
    var likes: Set<String>
    var dislikes: Set<String>
    let timeCreated: Date
    var expireDate: Date?
    // Firebase
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    // Hashable
    var hashValue: Int {
        return id.hashValue
    }

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
    
    // MARK: - ObjectMapper
    required init(map: Map) throws {
        location        = try map.value("location")
        kind            = try map.value("kind")
        descriptionText = try? map.value("description")
        imagePath       = try? map.value("image")
        userID          = try map.value("user")
        likes           = (try? map.value("likes")) ?? []
        dislikes        = (try? map.value("dislikes")) ?? []
        timeCreated     = try map.value("timeCreated", using: ISO8601DateTransform())
        expireDate      = try? map.value("expireDate", using: ISO8601DateTransform())
    }
    
    func mapping(map: Map) {
        location        >>> map["location"]
        kind            >>> map["kind"]
        descriptionText >>> map["description"]
        imagePath       >>> map["image"]
        userID          >>> map["user"]
        timeCreated     >>> (map["timeCreated"], ISO8601DateTransform())
        expireDate      >>> (map["expireDate"], ISO8601DateTransform())
    }

    // MARK: - Functions
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
    
    func toDatabase() -> DocumentReference {
        // Data from object in JSON
        let data = self.toJSON()
        // Upload data to database
        ref = db.collection("speedCameras").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
        return ref!
    }
    
    // Adds imagePath to item in database
    func addImagePath(path: String) {
        db.collection("speedCameras").document(ref!.documentID).setData(["image" : path], merge: true)
    }
    
    func setId(id: String) {
        self.id = id
    }

    // Equatable
    static func == (lhs: SpeedCamera, rhs: SpeedCamera) -> Bool {
        return lhs.id == rhs.id
    }
}
