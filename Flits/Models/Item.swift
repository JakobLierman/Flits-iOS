//
//  Item.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation
import Firebase

protocol Item {

    // Returns likes
    func getLikes() -> Int
    // Returns dislikes
    func getDislikes() -> Int
    // Likes the post
    func like(userId: String)
    // Dislikes the post
    func dislike(userId: String)
    // Removes like or dislike
    func removeLike(userId: String)

    // Uploads item to database, returns ID
    func toDatabase() -> DocumentReference

}
