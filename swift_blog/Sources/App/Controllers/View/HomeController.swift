//
//  HomeController.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor
import MySQL

final class HomeController: RouteCollection {

    
    func boot(router: Router) throws {
        //首页
         router.get("", use: home)
         router.get("home", use: home)
         router.get("post", use: postGet)
         router.get("post/page",Int.parameter, use: postGet)
         router.get("post/detail",Int.parameter, use: postDetail)
         router.get("config", use: configGet)
    }
    
    func home(_ req: Request) throws -> Future<View> {
        return try req.view().render("home")
    }
   
    func configGet(_ req: Request) throws -> Future<Response> {
        return HomeConfig.query(on: req).first().flatMap{
            return try APIResponse<HomeConfig>.init(data: $0).encode(for: req)
        }
    }
    
    //我需要返回一个这样的数据
    /**
     {
        [
     {"year": 2018,
     "data": posts}
     {"year": 2017,
     "data": posts
     }
     ]
     }
     */
    
    struct TestPostResponse: Content {
        var year: Int
        var posts: [Post]
        init(year: Int) {
            self.year = year
            self.posts = [Post]()
        }
    }
    
    //每页默认获取20条
    func postGet(_ req: Request) throws -> Future<Response> {
        var page = try? req.parameters.next(Int.self)
            page = page ?? 0
        
        
        
        return  req.withPooledConnection(to: .mysql) { conn  in
            defer {
                try? req.releaseCachedConnections()
            }
            //如果索引是0的话根本不会发出来
            //如果索引是最后一个 则返回一个提示 说已是最后一页 就行了

            let size = 15;
            let lower = size * page!
            let upper = size * (page!+1)-1
            print(page)
            print(lower)
            print(upper)
            return Post.query(on: conn)
                .sort(\Post.updatedAt, .descending)
                .range(lower: size * page!, upper: size * (page!+1)-1)
                .all().flatMap { posts in
                    //对所获得的数据进行重组
                    // [post]
                    var testPosts = [TestPostResponse]()
                    if  posts.count > 0 {
                        var yearSet = Set<Int>.init()
                        //去重
                        posts.forEach{ post in
                            //利用set 去重
                            yearSet.insert(post.postYear!)
                        }
                        let years = yearSet.sorted() {$0 > $1}
                       
                        print(years)
                        //获取值
                        years.forEach{ index in
                            var testPost = TestPostResponse(year: index)
                            posts.forEach{ obj in
                                if obj.postYear! == index {
                                    testPost.posts.append(obj)
                                }
                            }
                            testPosts.append(testPost)
                        }
                    }
                    //然后排序
                return try APIResponse<[TestPostResponse]>.init(data: testPosts).encode(for: req)
            }
        }
        
    }
    
    func postDetail(_ req: Request) throws -> Future<Response> {
        let postId = try req.parameters.next(Int.self)
        return  req.withPooledConnection(to: .mysql) { conn  in
            defer {
                try? req.releaseCachedConnections()
            }
            return Post.query(on: conn)
                .filter(custom: \Post.id == postId)
                .first()
                .flatMap {
                    if $0 == nil {
                        return try APIResponse<Empty>().encode(for: req)
                    }else {
                        //先更新后返回
                        var post = $0!
                            post.views = post.views! + 1;
                        return post.update(on: conn).flatMap { _ in
                            return try APIResponse<Post>(data: post).encode(for: req)
                        }
                        
                    }
            }
        }
    }

    
}
