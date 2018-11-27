//
//  AuthMiddleware.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor
public class AuthMiddleware: Middleware {
    
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        //经过这个认证的 必须存在session 不存在则代表未登录 直接跳转到登录页面
        
        
        
        return try next.respond(to: request)
    }
    
   
    
    
}
