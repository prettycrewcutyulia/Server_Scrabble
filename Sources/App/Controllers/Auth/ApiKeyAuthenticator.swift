//
//  ApiAuthenticator.swift
//
//
//  Created by Ярослав Гамаюнов on 28.04.2024.
//

import Vapor

struct APIKeyAuthenticator: Middleware {
    let apiKeyHeaderName = "ApiKey"

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        
        // Проверяем наличие заголовка 'apiKey'
        guard let apiKey = request.headers.first(name: apiKeyHeaderName) else {
            // Если ключа нет, возвращаем ошибку
            return request.eventLoop.makeFailedFuture(Abort(.unauthorized, reason: "ApiKey header is not set."))
        }
        
        return ApiKey.find(UUID(apiKey), on: request.db)
            .unwrap(or: Abort(.notFound, reason: "ApiKey is not valid"))
            .tryFlatMap { user in
                let now = Date()
                if (user.expiresAt != nil && user.expiresAt! < now) {
                    throw Abort(.forbidden, reason: "ApiKey is expired.")
                }
                return next.respond(to: request)
            }
    }
}
