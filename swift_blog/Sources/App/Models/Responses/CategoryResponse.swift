//
//  CategoryResponse.swift
//  App
//
//  Created by chenyh on 2018/11/16.
//

import Vapor

struct CategoryResponse: Content {
    var categories: [Category]
}
