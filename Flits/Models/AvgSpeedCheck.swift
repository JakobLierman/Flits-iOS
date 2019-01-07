//
//  AvgSpeedCheck.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class AvgSpeedCheck: Item, ImmutableMappable, Hashable, Comparable {

    // MARK: - Properties
    var id: String = ""
    let beginLocation: String
    let endLocation: String
    let userID: String
    var likes: Set<String>
    var dislikes: Set<String>
    let timeCreated: Date
    // Firebase
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    // Hashable
    var hashValue: Int {
        return id.hashValue
    }

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
        beginLocation = try map.value("beginLocation")
        endLocation = try map.value("endLocation")
        userID = try map.value("user")
        likes = (try? map.value("likes")) ?? []
        dislikes = (try? map.value("dislikes")) ?? []
        timeCreated = try map.value("timeCreated", using: ISO8601DateTransform())
    }

    func mapping(map: Map) {
        beginLocation >>> map["beginLocation"]
        endLocation >>> map["endLocation"]
        userID >>> map["user"]
        timeCreated >>> (map["timeCreated"], ISO8601DateTransform())
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

    @discardableResult func toDatabase() -> DocumentReference {
        // Data from object in JSON
        let data = self.toJSON()
        // Upload data to database
        ref = db.collection("avgSpeedChecks").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
        return ref!
    }

    func setId(id: String) {
        self.id = id
    }

    // Equatable
    static func == (lhs: AvgSpeedCheck, rhs: AvgSpeedCheck) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Comparable
    static func < (lhs: AvgSpeedCheck, rhs: AvgSpeedCheck) -> Bool {
        return lhs.timeCreated < rhs.timeCreated
    }

}
