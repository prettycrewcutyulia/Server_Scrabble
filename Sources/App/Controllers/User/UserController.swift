//
//  File.swift
//  
//
//  Created by Карим on 12.06.2024.
//

import Foundation
import Vapor
import JWT
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userGroup = routes
            .grouped("user")
            .protectedWithApiKey()
        
        userGroup.delete("", ":userId", use: {try await self.delete_user($0)})
    }
    
    func delete_user(_ req: Request) async throws -> HTTPStatus {
        let payload = try req.jwt.verify(as: UserPayload.self)

        if let userIdString = req.parameters.get("userId"), let userId = UUID(userIdString) {
            if (UUID(payload.userID) != userId) {
                throw Abort(.forbidden)
            }
            
            let user = try await User.query(on: req.db)
                .filter(\.$id == userId).first()
            try await user?.delete(on: req.db)
            return .noContent
        } else {
            throw Abort(.notFound)
        }
    }
}