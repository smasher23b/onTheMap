//
//  UserProfile.swift
//  onTheMapProject
//
//  Created by Ivan Jovany Arellano Gaspar on 7/10/20.
//  Copyright © 2020 Ivan Jovany Arellano Gaspar. All rights reserved.
//
import Foundation

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickName
    }
}
