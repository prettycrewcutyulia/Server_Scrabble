//
//  CreateGameRoom.swift
//
//
//  Created by Irina Pechik on 21.04.2024.
//

import Fluent
import Vapor

struct CreateGameRoom: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        let schema = database.schema("gameRooms")
            .id()
            .field("adminNickname", .string, .required)
            .field("roomCode", .string)
            .field("gameStatus", .string, .required)
            .field("currentNumberOfChips", .int, .required)
        try await schema.create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("gameRooms").delete()
    }
}
