//
//  ChipsOnField.swift
//  
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor

final class ChipsOnField: Model, Content {
    static let schema = "chipsOnField"
    
    @ID
    var id: UUID?
    
    @Field(key: "gameId")
    var gameId: UUID
    
    @Field(key: "coordinate")
    var coordinate: Coordinate
    
    @Field(key: "chips")
    var chips: Chips
    
    init() { }

    init(id: UUID? = nil, gameId: UUID, chips: Chips, coordinate: Coordinate) {
        self.id = id
        self.gameId = gameId
        self.chips = chips
        self.coordinate = coordinate
    }
}

