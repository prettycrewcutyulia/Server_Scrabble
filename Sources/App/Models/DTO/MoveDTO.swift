//
//  MoveDTO.swift
//
//
//  Created by Юлия Гудошникова on 30.04.2024.
//

import Foundation
import Vapor

struct MoveDTO: Codable, Content {
    var gameId: UUID
    var gamerId: UUID
    var startCoordinate: Coordinate
    var stopCoordinate: Coordinate
    var chips: [ChipsOnFieldDTO]
}
