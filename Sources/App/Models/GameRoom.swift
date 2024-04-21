//
//  GameRoom.swift
//
//
//  Created by Irina Pechik on 21.04.2024.
//

import Fluent
import Vapor

final class GameRoom: Model, Content {
    static let schema: String = "gameRooms"
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "adminNickname")
    var adminNickname: String
    
    @Field(key: "roomCode")
    var roomCode: String?
    
    @Field(key: "gameStatus")
    var gameStatus: String
    
    @Field(key: "currentNumberOfChips")
    var currentNumberOfChips: Int
    
    init() {}
    
    init(id: UUID? = nil, adminNickname: String, roomCode: String? = nil,
         gameStatus: String, currentNumberOfChips: Int) {
        self.id = id
        self.adminNickname = adminNickname
        self.roomCode = roomCode
        self.gameStatus = gameStatus
        self.currentNumberOfChips = currentNumberOfChips
    }
    
    
}
