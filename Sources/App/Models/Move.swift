//
//  Move.swift
//  
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor

final class Move: Model, Content {
    static let schema = "movesInGameRoom"
    
    @ID
    var id: UUID?
    
    @Field(key: "gameId")
    var gameId: UUID
    
    @Field(key: "gamerId")
    var gamerId: UUID
    
    @Field(key: "startCoordinate")
    var startCoordinate: Coordinate
    
    @Field(key: "stopCoordinate")
    var stopCoordinate: Coordinate
    
    @Field(key: "word")
    var word: String
    
    init() { }

    init(
        id: UUID? = nil,
        gameId: UUID,
        gamerId: UUID,
        startCoordinate: Coordinate,
        stopCoordinate: Coordinate,
        word: String
    ) {
        self.id = id
        self.gameId = gameId
        self.gamerId = gamerId
        self.startCoordinate = startCoordinate
        self.stopCoordinate = stopCoordinate
        self.word = word
    }
}
