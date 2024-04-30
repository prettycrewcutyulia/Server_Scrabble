//
//  User.swift
//
//
//  Created by Yaroslav Gamayunov on 21.04.2024.
//

import Fluent
import Vapor

final class User: Model, Content, Authenticatable {
    
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "nickName")
    var nickName: String
    
    @Field(key: "password")
    var password: String
    
    init() { }

    init(id: UUID? = nil, nickName: String, password: String) {
        self.id = id
        self.nickName = nickName
        self.password = password
    }
}
