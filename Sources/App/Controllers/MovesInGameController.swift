//
//  MovesInGameController.swift
//  
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor
import JWT

struct MovesInGameController: RouteCollection {
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let movesGroup = routes
            .grouped("moves")
            //.protectedWithApiKeyAndUserAuth()
        
        movesGroup.get("gameId", ":gameId", use: { try await MovesFunction.getMovesByGameId($0)} )
    }
}


enum MovesFunction {
    static func getMovesByGameId(_ req: Request) async throws -> [Move] {
        guard let gameIDString = req.parameters.get("gameId"),
              let gameID = UUID(gameIDString)
        else {
            throw Abort(.badRequest)
        }
        
        let movesQuery = try await Move.query(on: req.db).filter(\.$gameId == gameID).all()
        
        return movesQuery
    }
    // Получить комнату по id.
   static func getGameRoom(_ req: Request) async throws -> GameRoom {
        guard let gameRoom = try await GameRoom.find(req.parameters.get("gameRoomId"), on: req.db)
        else {
            throw Abort(.notFound)
        }
        return gameRoom
    }
}
