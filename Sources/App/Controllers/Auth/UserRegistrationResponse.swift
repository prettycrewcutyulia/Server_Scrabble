//
//  File.swift
//  
//
//  Created by Ярослав Гамаюнов on 30.04.2024.
//

import Vapor

struct UserRegistrationResponse: Content {
    let id: String
    
    init(id: String) {
        self.id = id
    }
}
