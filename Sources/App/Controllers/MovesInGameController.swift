//
//  MovesInGameController.swift
//
//
//  Created by Юлия Гудошникова on 29.04.2024.
//

import Fluent
import Vapor
import JWT

struct MovesInGameController: RouteCollection {
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let movesGroup = routes
            .grouped("moves")
            .protectedWithApiKeyAndUserAuth()
        
        movesGroup.get("gameId", ":gameId", use: { try await MovesFunction.getMovesByGameId($0) })
        movesGroup.post("addMove", use: { try await MovesFunction.createMove($0) })
        movesGroup.delete("deleteMove", use: { try await MovesFunction.deleteMove($0)})
        movesGroup.get("checkWord", ":word", use: { try await MovesFunction.checkWord($0) })
        movesGroup.get("getPointsByGamerId", ":gamerId", "gameId", ":gameId", use: { try await MovesFunction.getPointsByGamerId($0) })
    }
}


enum MovesFunction {
    // Получить все ходы в игре
    static func getMovesByGameId(_ req: Request) async throws -> [MoveDTO] {
        guard let gameIDString = req.parameters.get("gameId"),
              let gameID = UUID(gameIDString)
        else {
            throw Abort(.badRequest)
        }
        
        
        let movesQuery = try await Move.query(on: req.db)
            .filter(\.$gameId == gameID)
            .all()
        
        var result: [MoveDTO] = []
        
        for move in movesQuery {
            let chips = try await ChipsOnField.query(on: req.db).filter(\.$moveId == move.id!).all()
            result.append(
                MoveDTO(
                    gameId: move.gameId,
                    gamerId: move.gamerId,
                    startCoordinate: move.startCoordinate,
                    stopCoordinate: move.stopCoordinate,
                    chips: chips.map { chip in
                        return ChipsOnFieldDTO(coordinate: chip.coordinate, chip: chip.chip)
                    }
                )
            )
        }
        
        return result
    }
    
    // Сделать ход(поставить слово на карту)
    static func createMove(_ req: Request) async throws -> Response {
        let moveDTO = try req.content.decode(MoveDTO.self)
        let move = Move(
            gameId: moveDTO.gameId,
            gamerId: moveDTO.gamerId,
            startCoordinate: moveDTO.startCoordinate,
            stopCoordinate: moveDTO.stopCoordinate
        )
        
        guard let gamer = try await GamerIntoRoom.query(on: req.db)
            .filter(\.$roomId == move.gameId)
            .filter(\.$gamerId == move.gamerId)
            .first() else {
            return Response(status: .badRequest, body: "Игрок не найден.")
        }
        
        var gamerChips = gamer.chips
        
        let chips = moveDTO.chips.map { chip in
            return chip.chip
        }
        
        for chip in chips {
            if let index = gamerChips?.firstIndex(of: chip) {
                gamerChips?.remove(at: index)
            } else {
                return Response(status: .badRequest, body: "Игрок не может поставить эти буквы.")
            }
        }
        
        try await move.save(on: req.db)
        
        guard let id = move.id else {
            return Response(status: .badRequest)
        }
        
        let chipsOnField = moveDTO.chips.map { chip in
            return ChipsOnField(
                moveId: id, chip: chip.chip, coordinate: chip.coordinate
            )
        }
        
        for chip in chipsOnField {
            try await chip.save(on: req.db)
        }
        
        gamer.chips = gamerChips
        try await gamer.save(on: req.db)
        
        return Response(status: .created)
    }
    
    // Удалить ход
    static func deleteMove(_ req: Request) async throws -> Response {
        let move = try req.content.decode(Move.self)
        guard let move = try await Move.query(on: req.db)
            .filter(\.$gameId == move.gameId)
            .filter(\.$gamerId == move.gamerId)
            .filter(\.$startCoordinate == move.startCoordinate)
            .filter(\.$stopCoordinate == move.stopCoordinate)
            .first() else {
            return Response(status: .badRequest, body: "Такой ход не найден.")
        }
        
        let chips = try await ChipsOnField.query(on: req.db)
            .filter(\.$moveId == move.id!).all()
        
        // Удалим все chips связанные с найденным ходом
        for chip in chips {
            try await chip.delete(on: req.db)
        }
        
        // Удалим найденный ход
        try await move.delete(on: req.db)
        
        return Response(status: .ok, body: "Ход и связанные с ним фишки успешно удалены из базы данных.")
        
    }
    
    // Проверить орфографию слова
    static func checkWord(_ req: Request) async throws -> Response {
        guard let word = req.parameters.get("word") else {
            throw Abort(.badRequest, reason: "Не удалось получить слово для проверки орфографии.")
        }

        // URL для запроса к API Яндекс.Спеллер
        let urlString = "https://speller.yandex.net/services/spellservice.json/checkText?text=\(word)"

        // Создаем URL из строки
        guard let url = URL(string: urlString) else {
            throw Abort(.internalServerError, reason: "Неверный URL")
        }

        // Создаем URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Создаем URLSession
        let session = URLSession.shared

        // Отправляем запрос
        let (data, _) = try await session.data(for: request)

        // Парсим JSON ответ
        guard let result = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            throw Abort(.internalServerError, reason: "Ошибка при обработке ответа от API")
        }

        // Проверяем результаты орфографии
        if !result.isEmpty {
            return Response(status: .custom(code: 404, reasonPhrase: "Ошибка в орфографии найдена"))
        } else {
            return Response(status: .custom(code: 200, reasonPhrase: "Ошибка в орфографии не найдена"))
        }
    }

    // Получить очки игрока
    static func getPointsByGamerId(_ req: Request) async throws -> Int {
        guard let gamerIdString = req.parameters.get("gamerId"),
              let gamerId = UUID(gamerIdString),
              let gameIdString = req.parameters.get("gameId"),
              let gameId = UUID(gameIdString)
        else {
            throw Abort(.badRequest, reason: "Не удалось получить параметры запроса.")
        }
        
        let moves = try await Move.query(on: req.db)
            .filter(\.$gamerId == gamerId)
            .filter(\.$gameId == gameId)
            .all()
        
        var result = 0
        
        for move in moves {
            let chips = try await ChipsOnField.query(on: req.db).filter(\.$moveId == move.id!).all()
            
             result += FieldService.wordScoring(word: chips)
        }
             
        return result
    }
}
