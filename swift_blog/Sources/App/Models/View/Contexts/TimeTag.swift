//
//  TimeTag.swift
//  App
//
//  Created by chenyh on 2018/11/19.
//

import Vapor
import Leaf

final class TimeTag: TagRenderer {
    func render(tag: TagContext) throws -> EventLoopFuture<TemplateData> {
        try tag.requireNoBody()
        try tag.requireParameterCount(1)
        let timestamp = tag.parameters[0].string ?? ""
        
        let dateString = Date.string(from: timestamp)
        //
        return Future.map(on: tag) { .string(dateString) }
    }
}
//根据这个生成对应的时间
extension Date {
   
    
    static func string(from timestamp: String) -> String {
        if !(timestamp.count > 0) {
            return ""
        }
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//            dateFormatter.timeZone = NSTimeZone.system
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp)!)
            print(date.description(with: NSLocale.system))
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    
}

