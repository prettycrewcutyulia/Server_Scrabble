//
//  UserPayload.swift
//  
//
//  Created by Ярослав Гамаюнов on 27.04.2024.
//

import Foundation
import JWT

// Полезная нагрузка JWT
struct UserPayload: JWTPayload {
    var userID: String
    var exp: ExpirationClaim

    func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
