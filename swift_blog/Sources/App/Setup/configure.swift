import Leaf
import Vapor
import FluentMySQL
/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    
    /// Register providers first
    try services.register(LeafProvider())
    try services.register(FluentMySQLProvider())
    

    /// Register routes to the router
    services.register(Router.self) { container -> EngineRouter in
        let router = EngineRouter.default()
        try routes(router, container)
        return router
    }
    
    /// Command Config
    var commandsConfig = CommandConfig.default()
    commands(config: &commandsConfig)
    services.register(commandsConfig)
    
    
    var databasesConfig = DatabasesConfig()
    try databases(config: &databasesConfig,env: env)
    services.register(databasesConfig)
    
    services.register { container -> LeafTagConfig in
        var config = LeafTagConfig.default()
 
        config.use(TimeTag(),as: "time")
        return config
    }
    
    
    services.register { container -> MigrationConfig in
        var migrationConfig = MigrationConfig()
        try migrate(migrations: &migrationConfig)
        return migrationConfig
    }
    services.register(APIKeyStorage(apiKey: "WO DU ZI TENG"))
    /// Use Leaf for rendering views
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    config.prefer(DictionaryKeyedCache.self, for: KeyedCache.self)
    
    var middlewaresConfig = MiddlewareConfig()
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)
    
}


