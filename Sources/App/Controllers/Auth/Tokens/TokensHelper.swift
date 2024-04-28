//
//  TokensHelper.swift
//
//
//  Created by Ярослав Гамаюнов on 27.04.2024.
//

import Foundation

import JWT

class TokensHelper {

    private enum Constants {
        static let expirationTime: TimeInterval = 3600 // Токен живет 1 час
    }
    
    /// Create payload for Access Token
    class func createPayload(from user: User) throws -> UserPayload {
        do {
            let expirationTime = ExpirationClaim(value: Date().addingTimeInterval(Constants.expirationTime))
            return UserPayload(userID: user.id!.uuidString, exp: expirationTime)
        } catch {
            throw JWTError.payloadCreation
        }
    }
    
    // Создает токен доступа, в котором передает данные об ID пользователя и времени, когда токен нужно перезапросить
    class func createAccessToken(from user: User, signers: JWTSigners) throws -> String {
        do {
            let payload = try TokensHelper.createPayload(from: user)
            return try signers.sign(payload)
        } catch {
            throw JWTError.createJWT
        }
    }
    
    // Проверяет токен на валидность и в случае успеха возвращает payload
    class func verifyToken(from tokenString: String, signers: JWTSigners) throws -> UserPayload {
        do {
            return try signers.verify(tokenString, as: UserPayload.self)
        } catch {
            throw JWTError.verificationFailed
        }
    }
}

extension JWTError {
    static let payloadCreation = JWTError.generic(identifier: "TokenHelpers.createPayload", reason: "User ID not found")
    static let createJWT = JWTError.generic(identifier: "TokenHelpers.createJWT", reason: "Error getting token string")
    static let verificationFailed = JWTError.generic(identifier: "TokenHelpers.verifyToken", reason: "JWT verification failed")
}
