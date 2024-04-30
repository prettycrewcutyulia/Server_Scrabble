//
//  ChipsOnField.swift
//  
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor

// Фишки на поле
final class ChipsOnField: Model, Content {
    static let schema = "chipsOnField"
    
    @ID
    var id: UUID?
    
    @Field(key: "moveId")
    var moveId: UUID
    
    @Field(key: "coordinate")
    var coordinate: Coordinate
    
    @Field(key: "chip")
    var chip: Chip
    
    init() { }

    init(id: UUID? = nil, moveId: UUID, chip: Chip, coordinate: Coordinate) {
        self.id = id
        self.moveId = moveId
        self.chip = chip
        self.coordinate = coordinate
    }
}

