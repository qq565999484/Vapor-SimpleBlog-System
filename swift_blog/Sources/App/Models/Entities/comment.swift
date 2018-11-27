//
//  comment.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor
import FluentMySQL
import MySQL

struct Comment: BaseModelType {
     static let name = "tb_comment"
    var id: Int?
    var ip: String?
    var username: String
    var content: String
    var postId: Int
    var createAt: Date?
    
    
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(Comment.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.username)
            builder.field(for: \.content, type: MySQLDataType.text)
            builder.unique(on: \.username)
            builder.field(for: \.ip)
            builder.field(for: \.postId)
            builder.field(for: \.createAt)
        }
    }
    
}
extension Comment {
    var post: Parent<Comment,Post> {
        return parent(\.postId)
    }
}
