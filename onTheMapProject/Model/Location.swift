//
//  Location.swift
//  onTheMapProject
//
//  Created by Ivan Jovany Arellano Gaspar on 7/10/20.
//  Copyright © 2020 Ivan Jovany Arellano Gaspar. All rights reserved.
//

import Foundation

struct Location: Codable {
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
    
    var locationLabel: String {
        var name = ""
        if let firstName = firstName {
            name = firstName
        }
        if let lastName = lastName {
            if name.isEmpty {
                name = lastName
            }
            else {
                name += "  \(lastName)"
            }
        }
        if name.isEmpty {
            name = "FirstName LastName"
        }
        return name
    }
}
