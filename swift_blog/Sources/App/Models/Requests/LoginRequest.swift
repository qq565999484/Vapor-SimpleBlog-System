//
//  LoginRequest.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor

struct LoginRequest: Content {
    var username: String
    var password: String
    
}
