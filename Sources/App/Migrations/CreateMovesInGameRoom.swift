//
//  CreateMovesInGameRoom.swift
//  
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor

struct CreateMovesInGameRoom: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        let schema = database.schema("movesInGameRoom")
            .id()
            .field("gameId", .uuid, .required)
            .field("gamerId", .uuid, .required)
            .field("startCoordinate", .json, .required)
            .field("stopCoordinate", .json, .required)
            .field("word", .string, .required)
        try await schema.create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("movesInGameRoom").delete()
    }
}
