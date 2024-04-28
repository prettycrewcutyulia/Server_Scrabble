//
//  CreateApiKey.swift
//
//
//  Created by Ярослав Гамаюнов on 28.04.2024.
//

import Fluent
import Vapor

struct CreateApiKey: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ApiKey.schema)
            .id()
            .field("expires_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ApiKey.schema).delete()
    }
}
