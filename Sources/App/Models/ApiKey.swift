//
//  ApiKey.swift
//
//
//  Created by Ярослав Гамаюнов on 28.04.2024.
//

import Fluent
import Vapor

final class ApiKey: Model, Content {
    static let schema = "api_keys"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "expires_at")
    var expiresAt: Date?
}
