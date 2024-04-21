//
//  GameRoomController.swift
//
//
//  Created by Irina Pechik on 21.04.2024.
//

import Fluent
import Vapor

struct GameRoomController: RouteCollection {
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let gameRoomsGroup = routes.grouped("gameRooms")
        gameRoomsGroup.post(use: {try await self.createGameRoom($0)})
        gameRoomsGroup.get(use: {try await self.getAllGameRooms($0)})
        gameRoomsGroup.get(":gameRoomId", use: {try await self.getGameRoom($0)})
    }
    
    func index(req: Request) async throws -> [GameRoom] {
        try await GameRoom.query(on: req.db).all()
    }
    
    // Создание комнаты.
    func createGameRoom(_ req: Request) async throws -> GameRoom {
        let gameRoom = try req.content.decode(GameRoom.self)
        
        try await gameRoom.save(on: req.db)
        return gameRoom
    }
    
    // Получение всех комнат.
    func getAllGameRooms(_ req: Request) async throws -> [GameRoom] {
        let gameRooms = try await GameRoom.query(on: req.db).all()
        return gameRooms
    }
    
    // Получить комнату по id.
    func getGameRoom(_ req: Request) async throws -> GameRoom {
        guard let gameRoom = try await GameRoom.find(req.parameters.get("gameRoomId"), on: req.db)
        else {
            throw Abort(.notFound)
        }
        return gameRoom
    }
    
}
