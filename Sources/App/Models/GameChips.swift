//
//  GameChips.swift
//  
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor

final class GameChips: Model, Content {
    static let schema = "gameChips"
    
    @ID
    var id: UUID?
    
    @Field(key: "gameId")
    var gameId: UUID
    
    @Field(key: "chips")
    var chips: Chips
    
    @Field(key: "quantity")
    var quantity: Int
    
    init() { }

    init(id: UUID? = nil, gameId: UUID, chips: Chips, quantity: Int) {
        self.id = id
        self.gameId = gameId
        self.chips = chips
        self.quantity = quantity
    }
}
