//
//  UserLoginResponse.swift
//
//
//  Created by Ярослав Гамаюнов on 17.06.2024.
//

import Vapor

struct UserLoginResponse: Content {
    let id: String
    let token: String
    
    init(id: String, token: String) {
        self.id = id
        self.token = token
    }
}
