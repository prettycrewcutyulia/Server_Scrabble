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
    
    @Field(key: "chip")
    var chip: Chip
    
    @Field(key: "quantity")
    var quantity: Int
    
    init() { }

    init(id: UUID? = nil, gameId: UUID, chip: Chip, quantity: Int) {
        self.id = id
        self.gameId = gameId
        self.chip = chip
        self.quantity = quantity
    }
}
