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
    var gamerId: UUID
    
    @Field(key: "roomId")
    var roomId: UUID
    
    @Field(key: "enteredPassword")
    var enteredPassword: String? // введенный пользователем код от комнаты.
    
    @Field(key: "chips")
    var chips: [Chips]?
    
    init() {}
    
    init(
        id: UUID? = nil,
        gamerId: UUID,
        roomId: UUID,
        enteredPassword: String? = nil,
        chips: [Chips]? = nil
    ) {
        self.id = id
        self.gamerId = gamerId
        self.roomId = roomId
        self.enteredPassword = enteredPassword
        self.chips = chips
    }
}
