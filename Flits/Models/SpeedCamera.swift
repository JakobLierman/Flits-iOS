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
    let kind: String
    var description: String?
    var imagePath: String?
    let timeCreated: Date
    var expireDate: Date?

    // MARK: Constructors
    init(location: String, kind: String, description: String? = nil, imagePath: String? = nil) {
        self.timeCreated = Date()
        self.location = location
        self.kind = kind
        self.description = description
        self.imagePath = imagePath
        self.expireDate = calculateExpireDate()
    }

    // MARK: Functions
    func calculateExpireDate() -> Date? {
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

}
