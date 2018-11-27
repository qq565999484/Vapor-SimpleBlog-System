//
//  databases.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor
import FluentMySQL //use your database driver here

public func databases(config: inout DatabasesConfig,env: Environment) throws {
    /// Register the databases
    if !env.isRelease {
        config.add(database: MySQLDatabase(config: MySQLDatabaseConfig.devloper()), as: .mysql)
    }else {
        config.add(database: MySQLDatabase(config: MySQLDatabaseConfig.release()), as: .mysql)
    }
}
