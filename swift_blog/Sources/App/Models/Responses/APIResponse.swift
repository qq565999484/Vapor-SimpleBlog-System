//
//  APIResponse.swift
//  App
//
//  Created by chenyh on 2018/11/22.
//

import Vapor

struct APIResponse<D>: Content where D: Content  {
    var code: Int
    var message: String
    var data: D?
    
    init(code: Int = 0,message: String = "请求成功",data: D? = nil) {
        self.code = code
        self.message = message
        self.data = data
    }

}

struct Empty: Content {
    
}
