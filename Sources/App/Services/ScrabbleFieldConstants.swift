//
//  ScrabbleFieldConstants.swift
//  
//
//  Created by Ярослав Гамаюнов on 30.04.2024.
//

import Foundation

struct ScrabbleFieldConstants {
    static let scrabbleBoard: [String: TileBonus] = [
        "A1": .tripleWordScore,
        "D1": .doubleLetterScore,
        "H1": .tripleWordScore,
        "L1": .doubleLetterScore,
        "O1": .tripleWordScore,
        "B2": .doubleWordScore,
        "F2": .tripleLetterScore,
        "J2": .tripleLetterScore,
        "N2": .doubleWordScore,
        "C3": .doubleWordScore,
        "G3": .doubleLetterScore,
        "I3": .doubleLetterScore,
        "M3": .doubleWordScore,
        "A4": .doubleLetterScore,
        "D4": .doubleWordScore,
        "H4": .doubleLetterScore,
        "L4": .doubleWordScore,
        "O4": .doubleLetterScore,
        "E5": .doubleWordScore,
        "K5": .doubleWordScore,
        "B6": .tripleLetterScore,
        "F6": .tripleLetterScore,
        "J6": .tripleLetterScore,
        "N6": .tripleLetterScore,
        "C7": .doubleLetterScore,
        "G7": .doubleLetterScore,
        "I7": .doubleLetterScore,
        "M7": .doubleLetterScore,
        "A8": .tripleWordScore,
        "D8": .doubleLetterScore,
        "H8": .star,
        "L8": .doubleLetterScore,
        "O8": .tripleWordScore,
        "C9": .doubleLetterScore,
        "G9": .doubleLetterScore,
        "I9": .doubleLetterScore,
        "M9": .doubleLetterScore,
        "B10": .tripleLetterScore,
        "F10": .tripleLetterScore,
        "J10": .tripleLetterScore,
        "N10": .tripleLetterScore,
        "E11": .doubleWordScore,
        "K11": .doubleWordScore,
        "A12": .doubleLetterScore,
        "D12": .doubleWordScore,
        "H12": .doubleLetterScore,
        "L12": .doubleWordScore,
        "O12": .doubleLetterScore,
        "C13": .doubleWordScore,
        "G13": .doubleLetterScore,
        "I13": .doubleLetterScore,
        "M13": .doubleWordScore,
        "B14": .doubleWordScore,
        "F14": .tripleLetterScore,
        "J14": .tripleLetterScore,
        "N14": .doubleWordScore,
        "A15": .tripleWordScore,
        "D15": .doubleLetterScore,
        "H15": .tripleWordScore,
        "L15": .doubleLetterScore,
        "O15": .tripleWordScore
    ]
    
    // Хранит кортежи вида (Буква,Цена,Количество) - начальное распределение фишек в игре
    static let initialChipDistribution = [
        ("А", 1, 8), ("Б", 3, 2), ("В", 1, 4), ("Г", 3, 2),
        ("Д", 2, 4), ("Е", 1, 8), ("Ё", 3, 1), ("Ж", 5, 1),
        ("З", 5, 2), ("И", 1, 5), ("Й", 4, 1), ("К", 2, 4),
        ("Л", 2, 4), ("М", 2, 3), ("Н", 1, 5), ("О", 1, 10),
        ("П", 2, 4), ("Р", 1, 5), ("С", 1, 5), ("Т", 1, 5),
        ("У", 2, 4), ("Ф", 10, 1), ("Х", 5, 1), ("Ц", 5, 1),
        ("Ч", 5, 1), ("Ш", 8, 1), ("Щ", 10, 1), ("Ъ", 10, 1),
        ("Ы", 4, 2), ("Ь", 3, 2), ("Э", 8, 1), ("Ю", 8, 1),
        ("Я", 3, 2)
    ]
}
