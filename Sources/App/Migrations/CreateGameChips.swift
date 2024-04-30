//
//  CreateGameChips.swift
//  
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor

struct CreateGameChips: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        let schema = database.schema("gameChips")
            .id()
            .field("gameId", .uuid, .required)
            .field("chip", .json, .required)
            .field("quantity", .int, .required)
        try await schema.create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("gameChips").delete()
    }
}
