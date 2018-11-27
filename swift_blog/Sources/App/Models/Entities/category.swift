//
//  category.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor
import FluentMySQL
import MySQL


struct  Category: BaseModelType {
    static let name = "tb_category"
    var id: Int?
    var title: String
    var createAt: Date? = Date.SystemDate
    var updatedAt: Date? = Date.SystemDate

    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(Category.self, on: conn) { build in
            build.field(for: \.id, isIdentifier: true)
            //标题不能为空 默认
            let titleConstraint = MySQLColumnConstraint.constraint(._notNull,nil)
            build.field(for: \.title, type: MySQLDataType.text, titleConstraint)
            //提供一个默认值
            build.field(for: \.createAt )
            build.field(for: \.updatedAt)
        }
    }
    
    static func queryAllValue(on req: Request) -> Future<CategoryResponse> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return Category.query(on: conn).all()
            }.map {
                return  CategoryResponse(categories: $0)
        }
    }
    
    static func get(on req: Request,by id: Int) -> Future<Category> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return Category.query(on: conn).filter(\Category.id == id).first().unwrap(or: MySQLError.init(identifier: "category", reason: "没有该类别!"))
        }
    }
    func add(on req: Request) -> Future<Category> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return self.save(on: conn)
        }
    }
    
    func edit(on req: Request) -> Future<Category> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return self.update(on: conn)
        }
    }
    static func delete(on req: Request,by id: Int) -> Future<Void> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return Category.query(on: conn).filter(\Category.id == id).first().unwrap(or: MySQLError.init(identifier: "category", reason: "没有该类别!")).flatMap{ category in
                return  category.delete(on: conn)
            }
        }
    }
   
}

extension Date {
    
    static var SystemDate: Date {
        let date = Date()
        let timeZone = NSTimeZone.system
        return date.addingTimeInterval(TimeInterval(timeZone.secondsFromGMT()))
    }
    
}

extension Category {
    var posts: Children<Category,Post> {
        return children(\.categoryId)
    }
}
