//
//  config.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor
import FluentMySQL


struct HomeConfig: BaseModelType {
    static let name = "tb_config"
    var id: Int?
    var title: String?
    var url: String?
    var keywords: String?
    var description: String?
    var email: String?
    var timezone: Date?
    var start: Int?
    var qq: String?
    
    //这块需要返回一个HomeContext对象
    static func queryAllValue(on req: Request) -> Future<HomeConfig?> {
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            return HomeConfig.query(on: conn).first()
        }
    }
    
    //这块需要返回一个HomeContext对象
    func updateConfig(on req: Request) -> Future<HomeConfig> {
        
        return req.requestPooledConnection(to: .mysql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .mysql) }
            
            return HomeConfig.query(on: conn).first().flatMap {
                if $0 == nil {
                    return self.create(on: conn)
                 }else {
                    var config = self
                    config.id = $0?.id
                    return config.update(on: conn)
                }
            }
            
        }
    }
    
    
    
    
}

