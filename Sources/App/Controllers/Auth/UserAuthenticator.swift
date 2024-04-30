//
//  JWTMiddleware.swift
//
//
//  Created by Ярослав Гамаюнов on 27.04.2024.
//

import Foundation
import Vapor
import JWTKit
import JWT

// По декодированному токену проверяем, что пользователь зарегистрирован
struct UserAuthenticator: JWTAuthenticator {
    func authenticate(jwt: UserPayload, for request: Request) -> EventLoopFuture<Void> {
        User.find(UUID(jwt.userID), on: request.db)
            .unwrap(or: Abort(.notFound))
            .map { user in
                request.auth.login(user)
            }
    }
}
