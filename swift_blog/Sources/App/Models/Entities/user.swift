//
//  user.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor
import FluentMySQL
import Authentication

struct User: BaseModelType {
    static let name = "tb_user"
    var id: Int?
    var username: String
    var password: String
    var email: String?
    var loginCount: Int?
    var lastTime: Date?
    var lastIp: String
    var state: Int?
    var createAt: Date?
    var updatedAt: Date?
    init(username: String,
         password: String,
         lastTime: Date = Date.SystemDate,
         lastIp: String) {
        self.username = username
        do {
           self.password = try HMAC.MD5.authenticate(password, key: username).hexEncodedString()
        } catch _ {
            self.password = ""
        }
        
        self.lastTime = lastTime
        self.lastIp = lastIp
    }
}

extension User {
    var posts: Children<User,Post> {
        return children(\.userId)
    }
    
    func isExist(on req: Request) -> Future<User?> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return User.query(on: conn)
                .filter(\.username == self.username)
                .filter(\.password == self.password)
                .first()
        }
    }
    func create(on req: Request) -> Future<User> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return self.create(on: conn)
        }
    }
    static func query(by id: Int,on req: Request) -> Future<User> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return User.query(on: conn).filter(\.id == id).first().unwrap(or: MySQLError.init(identifier: "USER", reason: "账号不存在"))
        }
    }
    func login(_ req: Request) throws -> Future<User> {
        //登录成功
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            
            return User.query(on: conn)
                .filter(\User.username == self.username)
                .filter(\User.password == self.password)
                .first()
                .unwrap(or: MySQLError.init(identifier: "USER", reason: "用户名密码错误"))
                .flatMap { user in
                  var theUser = user
                      theUser.lastIp = self.lastIp
                      theUser.lastTime = self.lastTime
                        try req.session()["userId"] = "\(theUser.id!)"
                        try req.session()["username"] = theUser.username
                        try req.session()["lastIp"] = theUser.lastIp
                        
                  return  theUser.update(on: conn, originalID: user.id)
                }
        }
        
        
    }
    
}

