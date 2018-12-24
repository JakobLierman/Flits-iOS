//
//  Item.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation

protocol Item {
    
    func getLikes() -> Int
    func getDislikes() -> Int
    func like(userUid: String)
    func dislike(userUid: String)
    func removeLike(userUid: String)
    
}
