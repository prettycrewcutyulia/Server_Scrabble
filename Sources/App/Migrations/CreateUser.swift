//
//  CreateUser.swift
//  
//
//  Created by Ярослав Гамаюнов on 28.04.2024.
//

import Fluent
import Vapor

struct CreateUser: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        let schema = database.schema("users")
            .id()
            .field("nickName", .string, .required)
            .field("password", .string)
        try await schema.create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("users").delete()
    }
}
