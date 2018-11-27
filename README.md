# Vapor-SimpleBlog-System

基于Swift语言Vapor框架 前端使用layui 布局 开发的个人博客后台系统(前端使用Vue前后端分离开发)

## 编译安装说明：

1 . 安装Vapor
    >[Vapor安装指南](https://docs.vapor.codes/3.0/install/macos/)
    
2 . 下载安装

    $ git clone https://github.com/qq565999484/Vapor-SimpleBlog-System.git
    $ cd Vapor-SimpleBlog-System/swift-blog

3 . 添加数据库

    mysql 新建blog_db数据库
4 . 代码区域修改mysql设置(如果)

    -Xcode中打开 ConstTool文件,修改代码区
    ```
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
    ```
 5 . 运行
 
    $ vapor update 
    $ vapor build 
    $ vapor run 
 6 . 浏览器演示
 
    http://localhost:8080/admin/login (后台)
    ##在数据库中添加默认账户和密码（自己定）
 7 . 感谢
    [使用Go-beego-layui开发个人简易Blog](https://github.com/Echosong/beego_blog)


