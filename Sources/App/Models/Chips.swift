//
//  Chips.swift
//
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor

// Фишка
struct Chip: Codable, Content, Equatable {
    var alpha: String
    var point: Int
}
