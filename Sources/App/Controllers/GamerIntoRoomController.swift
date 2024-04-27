//
//  File.swift
//  
//
//  Created by Irina Pechik on 21.04.2024.
//

import Fluent
import Vapor

extension UUID: Content {}

struct GamerIntoRoomController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let gamersIntoRoomsGroup = routes.grouped("gamersIntoRoom")
        gamersIntoRoomsGroup.post(use: {try await setGamerIntoRoom($0)})
        gamersIntoRoomsGroup.get("roomId", ":roomId", "gamersIds", use: {try await getAllGamersIdsByRoomId($0)})
        gamersIntoRoomsGroup.get("gamerId", ":gamerId", "room", use: {try await self.getRoomIdByGamerId($0)})
        gamersIntoRoomsGroup.delete("deleteRoomWithId", ":roomId", use: {try await self.deleteRoom($0)})
        gamersIntoRoomsGroup.delete("deleteGamer", ":gamerId", "withRoom", ":roomId", use: {try await self.deleteGamerFromRoom($0)})
    }
    
    func index(req: Request) async throws -> [GamerIntoRoom] {
        try await GamerIntoRoom.query(on: req.db).all()
    }
    
    // Создание связи между игроком и комнатой.
    func setGamerIntoRoom(_ req: Request) async throws -> GamerIntoRoom {
        let gamerIntoRoom = try req.content.decode(GamerIntoRoom.self)
        
        // Ищем комнату
        if let room = try await GameRoom.query(on: req.db)
            .filter(\.$id == gamerIntoRoom.roomId).first() {
            // Если комната уже стартовала игру, к ней нельзя присоединиться.
            if room.gameStatus != GameStatus.NotStarted.rawValue {
                throw Abort(.custom(code: 500, reasonPhrase: "Игра стартовала. Присоединиться к ней уже нельзя."))
            }
            
            // Если существует код у комнаты - проверям на соответствие его с введенным пользователем кодом.
            if let roomCode = room.roomCode {
                // Проверка на всякий случай, что пользователь ввел пароль.
                if let gamerEnteredPassword = gamerIntoRoom.enteredPassword {
                    if roomCode != gamerEnteredPassword {
                        throw Abort(.custom(code: 500, reasonPhrase: "Неверно введен код от игровой комнаты."))
                    }
                } else {
                    throw Abort(.custom(code: 404, reasonPhrase: "Введите пароль от комнаты."))
                }
            }
        } else {
            throw Abort(.custom(code: 404, reasonPhrase: "Такой игровой комнаты не существует"))
        }
        
        // Проверка на количество человек в комнате.
        let allGamersIntoRoom = try await GamerIntoRoom.query(on: req.db)
                                            .filter(\.$roomId == gamerIntoRoom.roomId)
                                            .all()
        if allGamersIntoRoom.count >= 4 {
            throw Abort(.custom(code: 500, reasonPhrase: "В игровой комнате не могут находиться более 4 человек"))
        }
        let isGamerAlreadyInRoom = try await GamerIntoRoom.query(on: req.db)
                                            .filter(\.$gamerId == gamerIntoRoom.gamerId)
                                            .all()
                                            .count > 0
        if isGamerAlreadyInRoom {
            throw Abort(.custom(code: 500, reasonPhrase: "Данный игрок уже привязан в комнате"))
        }
        try await gamerIntoRoom.save(on: req.db)
        return gamerIntoRoom
    }
    
    // Получение игровой комнаты по id игрока.
    func getRoomIdByGamerId(_ req: Request) async throws -> UUID {
        if let gamerIdString = req.parameters.get("gamerId"), let gamerId = UUID(gamerIdString) {
            guard let gamer = try await GamerIntoRoom.query(on: req.db)
                .filter(\.$gamerId == gamerId)
                .first()
            else {
                throw Abort(.notFound)
            }
            return gamer.roomId
        } else {
            throw Abort(.notFound)
        }
    }
    
    // Получение id всех игроков заданной комнаты.
    func getAllGamersIdsByRoomId(_ req: Request) async throws -> [UUID] {
        if let roomIdString = req.parameters.get("roomId"), let roomId = UUID(roomIdString) {
            let gamers = try await GamerIntoRoom.query(on: req.db)
                .filter(\.$roomId == roomId)
                .all()
            return gamers.map {g in
                return g.gamerId
            }
        } else {
            throw Abort(.notFound)
        }
    }
    
    // Удаление комнаты
    func deleteRoom(_ req: Request) async throws -> HTTPStatus {
        if let roomIdString = req.parameters.get("roomId"), let roomId = UUID(roomIdString) {
            let rooms = try await GamerIntoRoom.query(on: req.db)
                .filter(\.$roomId == roomId).all()
            if !rooms.isEmpty {
                let room = try await GameRoom.query(on: req.db)
                    .filter(\.$id == roomId).first()
                try await rooms.delete(on: req.db)
                try await room?.delete(on: req.db)
            } else {
                throw Abort(.custom(code: 404, reasonPhrase: "Данной комнаты не существует"))
            }
            return .noContent
        } else {
            throw Abort(.notFound)
        }
    }
    
    
    // Удаление игрока из комнаты.
    func deleteGamerFromRoom(_ req: Request) async throws -> HTTPStatus {
        // Если остался один человек в комнате и он хочет уйти, то удаляется еще и вся комната.
        if try await getAllGamersIdsByRoomId(req).count == 1 {
            return try await deleteRoom(req)
        }
        if let gamerIdString = req.parameters.get("gamerId"), let gamerId = UUID(gamerIdString) {
            let gamerIntoRoom = try await GamerIntoRoom.query(on: req.db)
                .filter(\.$gamerId == gamerId).first()
            if let gamerIntoRoom = gamerIntoRoom {
                try await gamerIntoRoom.delete(on: req.db)
                
            } else {
                throw Abort(.custom(code: 404, reasonPhrase: "Данного пользователя нет в комнате"))
            }
            return .noContent
        } else {
            throw Abort(.custom(code: 404, reasonPhrase: "Данного пользователя нет в комнате"))
        }
    }
}

