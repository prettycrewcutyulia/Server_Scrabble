//
//  LeaderBoard.swift
//  
//
//  Created by Ярослав Гамаюнов on 30.04.2024.
//

import Foundation
import Vapor

struct LeaderBoardPlayer: Content {
    let nickName: String
    let score: Int
}

struct LeaderBoard: Content {
    let players: [LeaderBoardPlayer]
    init(players: [(String, Int)]) {
        self.players = players.map { player in
            LeaderBoardPlayer(nickName: player.0, score: player.1)
        }
    }
}
