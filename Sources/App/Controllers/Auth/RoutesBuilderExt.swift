//
//  File.swift
//  
//
//  Created by Ярослав Гамаюнов on 28.04.2024.
//

import Vapor

extension RoutesBuilder {
    func protectedWithApiKey() -> RoutesBuilder {
        return self.grouped(APIKeyAuthenticator())
    }
    
    func protectedWithApiKeyAndUserAuth() -> RoutesBuilder {
        return self
            .grouped(APIKeyAuthenticator())
            .grouped(UserAuthenticator())
            .grouped(User.guardMiddleware())
    }
}
