//
//  ConstTool.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//

import Vapor
import FluentMySQL
import Authentication

struct APIKeyStorage: Service {
    let apiKey: String
}

// MARK: - mysql 连接
extension MySQLDatabaseConfig {
    static func devloper() -> MySQLDatabaseConfig {
        let config = MySQLDatabaseConfig(username: "root", password: "123456", database: "blog_db")
        return config
    }
    static func release() -> MySQLDatabaseConfig {
        let config = MySQLDatabaseConfig(username: "root", password: "123456", database: "blog_db")
        return config
    }
}

// MARK: - 得到用户名

struct ConstTool {

    static let PostImagePath = DirectoryConfig.detect().workDir + "Public/upload/"
    /// 根据原名称 生成编码后的
    ///
    /// - Parameter name: 图片原名称
    /// - Returns: 生成编码后的名称
    /// - Throws: "加密异常"
    static func geneImageName(by name: String) throws -> String {
        //也可加上时间戳
        let random = try "\(Int(Date.SystemDate.timeIntervalSince1970))_" +  CryptoRandom().generateData(count: 10).hexEncodedString() + "_" + name
        return random
    }
    
    
}


public typealias BaseModelType = MySQLModel & MySQLMigration & Content



extension Date {
    
    func year() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.year!
    }
    
    func month() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.month!
    }
    
    func day() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.day!
    }
    //MARK: 星期几
    func weekDay()->Int{
        let interval = Int(self.timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday == 0 ? 7 : weekday
    }
    //MARK: 当月天数
    func countOfDaysInMonth() ->Int {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)
        return (range?.length)!
    }
    //MARK: 当月第一天是星期几
    func firstWeekDay() ->Int {
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let firstWeekDay = (calendar as NSCalendar?)?.ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: self)
        return firstWeekDay! - 1
    }
    //MARK: - 日期的一些比较
    //是否是今天
    func isToday()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month && com.day == comNow.day
    }
    //是否是这个月
    func isThisMonth()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month
    }
}

