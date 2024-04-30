//
//  File.swift
//  
//
//  Created by Irina Pechik on 21.04.2024.
//

import Fluent
import Vapor

struct CreateGamerIntoRoom: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        let schema = database.schema("gamersIntoRoom")
            .id()
            .field("gamerId", .uuid, .required)
            .field("roomId", .uuid, .required)
            .field("enteredPassword", .string)
            .field("chips", .array(of: .json))
        try await schema.create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("gamersIntoRoom").delete()
    }
}
