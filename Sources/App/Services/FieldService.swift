//
//  File.swift
//  
//
//  Created by Юлия Гудошникова on 30.04.2024.
//

import Foundation
import Fluent

enum TileBonus {
    case doubleLetterScore
    case tripleLetterScore
    case doubleWordScore
    case tripleWordScore
    case star // Центральная клетка с дополнительным бонусом
    case none // Клетка без бонусов
}

struct FieldService {
    
    static func wordScoring(word: [ChipsOnField]) -> Int {
        var wordScore = 0
        var wordMultiplier = 1
            
        for chipOnField in word {
            // Получаем координаты фишки
            let coordKey = "\(chipOnField.coordinate.x.capitalized)\(chipOnField.coordinate.y)"
            
            // Получаем бонус клетки
            let tileBonus = ScrabbleFieldConstants.scrabbleBoard[coordKey, default: .none]
            
            // Очки за одну фишку
            var chipScore = chipOnField.chip.point
            
            // Применяем бонусы к буквам
            switch tileBonus {
            case .doubleLetterScore:
                chipScore *= 2
            case .tripleLetterScore:
                chipScore *= 3
            default:
                break
            }
            
            // Добавляем очки за фишку к общему счету слова
            wordScore += chipScore
            
            // Проверяем бонусы к словам
            switch tileBonus {
            case .star:
                wordMultiplier *= 2
            case .doubleWordScore:
                wordMultiplier *= 2
            case .tripleWordScore:
                wordMultiplier *= 3
            default:
                break
            }
        }
            
        // Применяем бонусы к слову
        wordScore *= wordMultiplier
        
        return wordScore
    }
    
    func createInitialGameChips(for gameId: UUID, on db: Database) -> EventLoopFuture<Void> {
        let chips = ScrabbleFieldConstants.initialChipDistribution.map { letter, points, quantity in
            GameChips(gameId: gameId, chip: Chip(alpha: letter, point: points), quantity: quantity)
        }
        
        return chips.map { chip in
            chip.create(on: db)
        }.flatten(on: db.eventLoop)
    }
}
