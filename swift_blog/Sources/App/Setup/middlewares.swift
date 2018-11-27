//
//  middlewares.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor

public func middlewares(config: inout MiddlewareConfig) throws {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    config.use(corsMiddleware)
    
    // config.use(FileMiddleware.self) // Serves files from `Public/` directory
    config.use(SessionsMiddleware.self)
    config.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    config.use(FileMiddleware.self)
    
    
    // Other Middlewares...
}
