//
//  PostResponse.swift
//  App
//
//  Created by chenyh on 2018/11/19.
//

import Vapor

struct PostResponse: Content {
    var posts: [Post]
    
    var categories: [Category]
    init(posts: [Post],categories: [Category]) {
        self.posts = posts
        self.categories = categories
    }
}

struct PostAddResponse: Content {
    var post: Post
    var categories: [Category]
    init(post: Post,categories: [Category]) {
        self.post = post
        self.categories = categories
    }
}


struct GetPostsByTitleRequest: Content {
    var title: String
    var categoryId: Int
}
struct DataResponse<T>: Content where T: Content {
    var datas: [T]
}
