//
//  AvgSpeedCheck.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import Foundation

struct AvgSpeedCheck {
    
    // MARK: Properties
    let beginLocation: String
    let endLocation: String
    var details: String?
    let timeCreated: Date
    
    // MARK: Constructors
    init(beginLocation: String, endLocation: String, details: String? = nil) {
        self.timeCreated = Date()
        self.beginLocation = beginLocation
        self.endLocation = endLocation
        self.details = details
    }
    
    // MARK: Functions

}
