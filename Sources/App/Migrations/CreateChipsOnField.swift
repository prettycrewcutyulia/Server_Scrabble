//
//  CreateChipsOnField.swift
//  
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor

struct CreateChipsOnField: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        let schema = database.schema("chipsOnField")
            .id()
            .field("gameId", .uuid, .required)
            .field("coordinate", .json, .required)
            .field("chip", .json, .required)
        try await schema.create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("chipsOnField").delete()
    }
}
