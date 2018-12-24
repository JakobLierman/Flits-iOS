//
//  PoliceCheck.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation

struct PoliceCheck {
    
    // MARK: Properties
    let location: String
    var details: String?
    let timeCreated: Date
    
    // MARK: Constructors
    init(location: String, details: String? = nil) {
        self.timeCreated = Date()
        self.location = location
        self.details = details
    }
    
    // MARK: Functions
    
}
