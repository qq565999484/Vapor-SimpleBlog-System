//
//  post.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor
import FluentMySQL

//var months = [
//    "Jan",
//    "Feb",
//    "Mar",
//    "April",
//    "May",
//    "Jun",
//    "Aug",
//    "Sept",
//    "Oct",
//    "Nov",
//    "Dec"
//];
struct Post: BaseModelType {
    static let name = "tb_post"
    var id: Int?
    var userId: Int?
    var title: String
    var content: String
    var tags: String?
    var views: Int? = 0
    var isTop: Int?
    var categoryId: Int
    var status: Int?
    var types: Int?
    var info: String?
    var url: String?
    var image: String?
    var createAt: Date?
    var updatedAt: Date?
    
    //下面这些属性 是不需要 迁移到数据库的
    //年月日
    var postYear: Int?
    var postMonth: Int?
    var postDay: Int?
    
    //发布帖子时的年月
    
    init(postRequest: PostRequest) {
        if postRequest.id != nil, let pid = Int(postRequest.id!) {
            self.id = pid
        }
        
        self.title = postRequest.title
        self.content = postRequest.content
        self.tags = postRequest.tags
        self.isTop = postRequest.isTop
        self.categoryId = postRequest.categoryId
        self.types = postRequest.types
        self.info = postRequest.info
        self.url = postRequest.url
        self.image = postRequest.image
        self.createAt = postRequest.createAt
        self.updatedAt = Date.SystemDate
        //根据创建日期 复制年月日
        self.postYear = Date.SystemDate.year()
        self.postMonth = Date.SystemDate.month()
        self.postDay = Date.SystemDate.day()
    }
    
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(Post.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.userId)
            builder.field(for: \.title)
            builder.field(for: \.tags)
            let defaultViews = MySQLColumnConstraint.default(\Post.views == 0)
            builder.field(for: \.views, type: MySQLDataType.int, defaultViews)
            builder.field(for: \.isTop)
            builder.field(for: \.categoryId)
            builder.field(for: \.status)
            builder.field(for: \.types)
            builder.field(for: \.image)
            builder.field(for: \.info)
            builder.field(for: \.createAt)
            builder.field(for: \.updatedAt)
            builder.field(for: \.postYear)
            builder.field(for: \.postMonth)
            builder.field(for: \.postDay)
            builder.field(for: \.content, type: MySQLDataType.text)
        }
    }
    
    static func queryAllValue(on req: Request) -> Future<PostResponse> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return Post.query(on: conn).all()
                .flatMap { posts in
                    return Category.query(on: conn).all().map {
                        return PostResponse.init(posts: posts, categories: $0)
                    }
                
                }
            }
    }
    
    static func get(on req: Request,by id: Int) -> Future<Post> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return Post.query(on: conn)
                .filter(\Post.id == id)
                .first()
                .unwrap(or: MySQLError.init(identifier: "category", reason: "没有该博文!"))
        }
    }
    func add(on req: Request) -> Future<Post> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return self.save(on: conn)
        }
    }
    
    func edit(on req: Request) -> Future<Post> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return self.create(orUpdate: true, on: conn)
        }
    }
    static func getPostsBy(year: Int,on req: Request) -> Future<[Post]> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return Post.query(on: conn)
                .filter(\Post.postYear == year)
                .sort(\Post.updatedAt)
                .all()
        }
        
    }
    static func delete(on req: Request,by id: Int) -> Future<Void> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return Post.query(on: conn).filter(\Post.id == id)
                .first()
                .unwrap(or: MySQLError.init(identifier: "category", reason: "没有该博文!"))
                .flatMap{ category in
                return  category.delete(on: conn)
            }
        }
    }
}


extension Post {
    var comments: Children<Post,Comment> {
        return children(\.postId)
    }
    
    var user: Parent<Post,User> {
        return parent(\.userId!)
    }
    var category: Parent<Post,Category> {
        return parent(\.categoryId)
    }
}



