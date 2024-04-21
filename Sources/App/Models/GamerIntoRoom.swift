//
//  GamersIntoRoom.swift
//
//
//  Created by Irina Pechik on 21.04.2024.
//

import Fluent
import Vapor

final class GamerIntoRoom: Model, Content {
    static let schema: String = "gamersIntoRoom"
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "gamerId")
    var gamerId: String
    
    @Field(key: "roomId")
    var roomId: String
    
    init() {}
    
    init(id: UUID? = nil, gamerId: String, roomId: String) {
        self.id = id
        self.gamerId = gamerId
        self.roomId = roomId
    }
}
