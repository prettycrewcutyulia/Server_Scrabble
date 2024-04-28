//
//  AuthController.swift
//
//
//  Created by YaroslavGamayunov on 21.04.2024.
//

import Vapor
import JWT
import Fluent

struct AuthController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let authGroup = routes
            .grouped("auth")
            .protectedWithApiKey()
        
        authGroup.post("login", use: {try await self.login($0)})
        authGroup.post("register", use: {try await self.register($0)})
    }

    // Метод для входа в систему и получения JWT
    func login(_ req: Request) async throws -> String {
        // Предположим, что у нас есть функция для проверки учетных данных пользователя
        let credentials = try req.content.decode(UserCredentials.self)
        let user = try await authenticate(credentials: credentials, on: req)
        
        let token = try TokensHelper.createAccessToken(from: user, signers: req.application.jwt.signers)
        return token
    }


    private func authenticate(credentials: UserCredentials, on req: Request) async throws -> User {
        // Поиск пользователя в базе данных по имени пользователя
        guard let user = try await User.query(on: req.db)
            .filter(\.$nickName == credentials.nickName)
            .first()
            .get() else {
            throw Abort(.unauthorized, reason: "User was not found.")
        }
        
        // Проверка пароля
        if user.password == credentials.password {
            // Возвращаем объект пользователя, если учетные данные верны
            return user
        } else {
            // Выбрасываем ошибку, если пароль не совпадает
            throw Abort(.unauthorized, reason: "Wrong password.")
        }
    }
    
    // Метод для регистрации нового пользователя
    func register(_ req: Request) async throws -> User {
        let credentials = try req.content.decode(UserCredentials.self)
        // Проверяем, существует ли уже пользователь с таким именем пользователя
        let existingUser = try await User.query(on: req.db)
            .filter(\.$nickName == credentials.nickName)
            .first()
            .get()

        guard existingUser == nil else {
            throw Abort(.badRequest, reason: "User already exists.")
        }

        // Создаем нового пользователя и сохраняем его в базе данных
        let newUser = User(nickName: credentials.nickName, password: credentials.password)
        try await newUser.save(on: req.db).get()

        return newUser
    }
}
