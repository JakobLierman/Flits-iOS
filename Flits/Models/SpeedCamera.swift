//
//  SpeedCamera.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation

struct SpeedCamera {
    
    // MARK: Properties
    let location: String
    var details: String?
    var imagePath: String?
    let timeCreated: Date
    var expireDate: Date?
    
    // MARK: Constructors
    init(location: String, details: String? = nil, imagePath: String? = nil, expireDate: Date? = nil) {
        self.timeCreated = Date()
        self.location = location
        self.details = details
        self.imagePath = imagePath
        self.expireDate = expireDate
    }
    
    // MARK: Functions
    
}