//
//  Chips.swift
//
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor

struct Chips: Codable, Content {
    var alpha: String
    var point: Int
}
