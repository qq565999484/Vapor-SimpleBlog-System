//
//  migrate.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor
import FluentMySQL //use your database driver here

public func migrate(migrations: inout MigrationConfig) throws {
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Post.self, database: .mysql)
    migrations.add(model: HomeConfig.self, database: .mysql)
    migrations.add(model: Comment.self, database: .mysql)
    migrations.add(model: Category.self, database: .mysql)
}
