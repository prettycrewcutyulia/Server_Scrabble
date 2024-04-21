//
//  CreateGameRoom.swift
//
//
//  Created by Irina Pechik on 21.04.2024.
//

import Fluent
import Vapor

struct CreateGameRoom: Migration {
    func prepare(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("gameRooms")
            .id()
            .field("adminNickname", .string, .required)
            .field("roomCode", .string)
            .field("gameStatus", .string, .required)
            .field("currentNumberOfChips", .int, .required)
            .create()
    }
    
    func revert(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("gameRooms").delete()
    }
}
