//
//  response.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor

struct ResponseView: Content {
    
    var code: Int
    var message: String
    init(code: Int,message: String) {
        self.code = code
        self.message = message
    }
}


