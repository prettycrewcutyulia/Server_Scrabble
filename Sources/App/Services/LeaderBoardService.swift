//
//  LeaderBoardService.swift
//
//
//  Created by Ярослав Гамаюнов on 30.04.2024.
//

import Foundation
import Fluent

struct LeaderBoardService {
    static func getNickNamesWithScores(for roomId: UUID, db: Database) async throws -> [(String, Int)] {
        var nickNamesWithScores: [(String, Int)] = []
        
        // Получаем всех игроков в комнате
        let gamersIntoRoom = try await GamerIntoRoom.query(on: db)
            .filter(\.$roomId == roomId)
            .all()
        
        // Для каждого игрока получаем его никнейм и счет
        for gamer in gamersIntoRoom {
            let user = try await User.find(gamer.gamerId, on: db)
            
            let moves = try await Move.query(on: db)
                .filter(\.$gamerId == gamer.gamerId)
                .filter(\.$gameId == roomId)
                .all()
            
            var score = 0
            for move in moves {
                let chips = try await ChipsOnField.query(on: db).filter(\.$moveId == move.id!).all()
                score += FieldService.wordScoring(word: chips)
            }
            
            // Добавляем никнейм и счет в результат
            nickNamesWithScores.append((user!.nickName, score))
        }
        
        nickNamesWithScores.sort { $0.1 > $1.1 }
        
        return nickNamesWithScores
    }
}
