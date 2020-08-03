//
//  LoginResponse.swift
//  onTheMapProject
//
//  Created by Ivan Jovany Arellano Gaspar on 7/10/20.
//  Copyright © 2020 Ivan Jovany Arellano Gaspar. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}
