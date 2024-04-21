//
//  File.swift
//  
//
//  Created by Irina Pechik on 21.04.2024.
//

import Fluent
import Vapor

struct GamerIntoRoomController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let gamersIntoRoomsGroup = routes.grouped("gamersIntoRoom")
        gamersIntoRoomsGroup.post(use: {try await self.setGamerIntoRoom($0)})
        gamersIntoRoomsGroup.get(use: {try await self.getHandler($0)})
        gamersIntoRoomsGroup.get("gamerId", ":gamerId", use: {try await self.getRoomIdByGamerId($0)})
        gamersIntoRoomsGroup.get("roomId", ":roomId", use: {try await self.getAllGamersIdsByRoomId($0)})

    }
    
    func index(req: Request) async throws -> [GamerIntoRoom] {
        try await GamerIntoRoom.query(on: req.db).all()
    }
    
    // Создание связи между игроком и комнатой.
    func setGamerIntoRoom(_ req: Request) async throws -> GamerIntoRoom {
        let gamerIntoRoom = try req.content.decode(GamerIntoRoom.self)
        
        try await gamerIntoRoom.save(on: req.db)
        return gamerIntoRoom
    }
    
    // Получение всей таблицы игрок-комната
    func getHandler(_ req: Request) async throws -> [GamerIntoRoom] {
        let gamersIntoRooms = try await GamerIntoRoom.query(on: req.db).all()
        return gamersIntoRooms
    }
    
    // Получение игровой комнаты по id игрока.
    func getRoomIdByGamerId(_ req: Request) async throws -> String {
        guard let gamer = try await GamerIntoRoom.query(on: req.db)
            .filter(\.$gamerId == req.parameters.get("gamerId") ?? "")
            .first()
        else {
            throw Abort(.notFound)
        }
        return gamer.roomId
    }
    
    // Получение всех игроков заданной комнаты.
    func getAllGamersIdsByRoomId(_ req: Request) async throws -> [String] {
        let gamers = try await GamerIntoRoom.query(on: req.db)
            .filter(\.$roomId == req.parameters.get("roomId") ?? "")
            .all()

        return gamers.map {g in
            return g.gamerId
        }
    }
}

