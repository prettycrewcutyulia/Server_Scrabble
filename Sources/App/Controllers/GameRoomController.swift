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
        gameRoomsGroup.get("getRoomCodeFor", ":gameRoomId", use: {try await self.getGameRoomCode($0)})
        gameRoomsGroup.get(":gameRoomId", "getChipsNumber", use: {try await self.getCurrentNumberOfChips($0)})
        gameRoomsGroup.put(":gameRoomId", "setChipsNumber", ":chipsNumber", use: {try await self.changeCurrentNumberOfChips($0)})
        gameRoomsGroup.put(":gameRoomId", "addOneChip", use: {try await self.addOneChip($0)})
        gameRoomsGroup.put(":gameRoomId", "subtractOneChip", use: {try await self.subtractOneChip($0)})
        gameRoomsGroup.put(":gameRoomId", "run", use: {try await self.runGame($0)})
        gameRoomsGroup.put(":gameRoomId", "pause", use: {try await self.pauseGame($0)})
        gameRoomsGroup.put(":gameRoomId", "end", use: {try await self.endedGame($0)})
        gameRoomsGroup.put(":gameRoomId", "end", use: {try await self.endedGame($0)})
        gameRoomsGroup.put(":gameRoomId", "stop", use: {try await self.stopGame($0)})

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
    
    // Получение пароля от комнаты.
    func getGameRoomCode(_ req: Request) async throws -> String {
        let gameRoom = try await getGameRoom(req)
        if let roomCode = gameRoom.roomCode {
            return roomCode
        } else {
            throw Abort(.custom(code: 404, reasonPhrase: "Для данной комнаты не существует пароля"))
        }
    }
    
    // Меняет статус игры на "Running"
    func runGame(_ req: Request) async throws -> GameRoom {
        let gameRoom = try await getGameRoom(req)
        gameRoom.gameStatus = GameStatus.Running.rawValue
        try await gameRoom.save(on: req.db)
        return gameRoom
    }
    
    // Меняет статус игры на "Pause"
    func pauseGame(_ req: Request) async throws -> GameRoom {
        let gameRoom = try await getGameRoom(req)
        gameRoom.gameStatus = GameStatus.Pause.rawValue
        try await gameRoom.save(on: req.db)
        return gameRoom
    }
    
    // Меняет статус игры на "Ended"
    func endedGame(_ req: Request) async throws -> GameRoom {
        let gameRoom = try await getGameRoom(req)
        gameRoom.gameStatus = GameStatus.Ended.rawValue
        try await gameRoom.save(on: req.db)
        return gameRoom
    }
    
    // Меняет статус игры на "Not Started", когда игру хотят начать заново
    func stopGame(_ req: Request) async throws -> GameRoom {
        let gameRoom = try await getGameRoom(req)
        gameRoom.gameStatus = GameStatus.NotStarted.rawValue
        try await gameRoom.save(on: req.db)
        return gameRoom
    }
    
    // Получить текущее количество фишек
    func getCurrentNumberOfChips(_ req: Request) async throws -> Int {
        let gameRoom = try await getGameRoom(req)
        return gameRoom.currentNumberOfChips
    }
    
    // Изменить текущее количество фишек
    func changeCurrentNumberOfChips(_ req: Request) async throws -> GameRoom {
        let gameRoom = try await getGameRoom(req)
        if let chipsNumberString = req.parameters.get("chipsNumber"), let chipsNumber = Int(chipsNumberString) {
            gameRoom.currentNumberOfChips = chipsNumber
            try await gameRoom.save(on: req.db)
            return gameRoom
        } else {
            throw Abort(.custom(code: 500, reasonPhrase: "Ошибка в пересчете количества фишек"))
        }
    }
    
    // Прибавить одну фишку к текущему количеству фишек
    func addOneChip(_ req: Request) async throws -> GameRoom {
        let gameRoom = try await getGameRoom(req)
        gameRoom.currentNumberOfChips += 1
        try await gameRoom.save(on: req.db)
        return gameRoom
    }
    
    // Убавить одну фишку из текущего количества фишек
    func subtractOneChip(_ req: Request) async throws -> GameRoom {
        let gameRoom = try await getGameRoom(req)
        if gameRoom.currentNumberOfChips == 0 {
            throw Abort(.custom(code: 500, reasonPhrase: "Невозможно уменьшить количество фишек, т.к. оно равно 0"))
        }
        gameRoom.currentNumberOfChips -= 1
        try await gameRoom.save(on: req.db)
        return gameRoom
    }
}
