//
//  PoliceCheck.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class PoliceCheck: Item, ImmutableMappable, Hashable, Comparable {

    // MARK: Properties
    var id: String = ""
    let location: String
    let descriptionText: String?
    var imagePath: String?
    let userID: String
    var likes: Set<String>
    var dislikes: Set<String>
    let timeCreated: Date
    let expireDate: Date
    // Firebase
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    // Hashable
    var hashValue: Int {
        return id.hashValue
    }

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

    // MARK: - ObjectMapper
    required init(map: Map) throws {
        location = try map.value("location")
        descriptionText = try? map.value("description")
        imagePath = try? map.value("image")
        userID = try map.value("user")
        likes = (try? map.value("likes")) ?? []
        dislikes = (try? map.value("dislikes")) ?? []
        timeCreated = try map.value("timeCreated", using: ISO8601DateTransform())
        expireDate = try map.value("expireDate", using: ISO8601DateTransform())
    }

    func mapping(map: Map) {
        location >>> map["location"]
        descriptionText >>> map["description"]
        imagePath >>> map["image"]
        userID >>> map["user"]
        timeCreated >>> (map["timeCreated"], ISO8601DateTransform())
        expireDate >>> (map["expireDate"], ISO8601DateTransform())
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

    func toDatabase() -> DocumentReference {
        // Data from object in JSON
        let data = self.toJSON()
        // Upload data to database
        ref = db.collection("policeChecks").addDocument(data: data) { err in
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
        db.collection("policeChecks").document(ref!.documentID).setData(["image": path], merge: true)
    }

    func setId(id: String) {
        self.id = id
    }

    // Equatable
    static func == (lhs: PoliceCheck, rhs: PoliceCheck) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Comparable
    static func < (lhs: PoliceCheck, rhs: PoliceCheck) -> Bool {
        return lhs.timeCreated < rhs.timeCreated
    }

}
