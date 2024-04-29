import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    
    app.migrations.add(CreateGameRoom())
    app.migrations.add(CreateGamerIntoRoom())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateApiKey())
    app.migrations.add(CreateMovesInGameRoom())
    app.migrations.add(CreateGameChips())
    app.migrations.add(CreateChipsOnField())
    
    do {
        try await app.autoMigrate().get()
        // register routes
        try routes(app)
    } catch {
        print("An error occurred during application configuration: \(error)")
        exit(0)
    }
    
    
    // Add HMAC with SHA-256 signer.
    app.jwt.signers.use(.hs256(key: "secret"))
}
