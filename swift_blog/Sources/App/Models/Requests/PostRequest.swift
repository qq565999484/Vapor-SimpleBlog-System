//
//  PostRequest.swift
//  App
//
//  Created by chenyh on 2018/11/20.
//

import Vapor

struct PostRequest: Content {
    var id: String?
    var title: String
    var content: String
    var tags: String?
    var isTop: Int? //存在则代表 选中 不存在则代表未选中
    var categoryId: Int
    var types: Int?
    var info: String?
    var url: String?
    var image: String?
    var createAt: Date?
    var updatedAt: Date?
}
