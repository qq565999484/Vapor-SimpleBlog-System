//
//  AuthController.swift
//  App
//
//  Created by chenyh on 2018/11/14.
//
import Vapor
import MySQL
import FluentQuery

final class AuthController: RouteCollection {
    
   
    func boot(router: Router) throws {
        //登录
        let adminRouter = router.grouped("admin")
            adminRouter.get("login", use: loginGet)
            adminRouter.get("logout", use: logout)
            adminRouter.post(LoginRequest.self, at: "login", use: loginPost)
            adminRouter.get("config", use: configGet)
            adminRouter.post(HomeConfig.self, at: "config", use: configPost)
        
            adminRouter.get("category", use: categoryGet)
            adminRouter.get("category/add",Int.parameter, use: categoryAddGet)
            adminRouter.get("category/add", use: categoryAddGet)
            adminRouter.post(Category.self, at: "category/add", use: categoryAddPost)
            adminRouter.post(Category.self, at: "category/edit", use: categoryEditPost)
            adminRouter.get("category/delete",Int.parameter, use: categoryDelete)
        
            adminRouter.get("post", use: postGet)
            adminRouter.get("post/add",Int.parameter, use: postAddGet)
            adminRouter.get("post/add", use: postAddGet)
            adminRouter.post(GetPostsByTitleRequest.self, at: "post", use: postAll)
        
            adminRouter.post(PostRequest.self, at: "post/add", use: postAddPost)
            adminRouter.post(PostRequest.self, at: "post/edit", use: postEditPost)
            adminRouter.get("post/delete",Int.parameter, use: postDelete)

//            adminRouter.post("upload", use: upload)
        
            adminRouter.post(UploadImageRequest.self, at: "upload", use: uploadImage)

    }
    struct ImageResonse<T: Content>: Content {
        var code: Int
        var msg: String
        var data: T?
    }


    //上传图片
    func uploadImage(_ req: Request,imageFields: UploadImageRequest) throws -> Future<Response> {
        guard let file = imageFields.file,let ext = file.ext else {
            throw Abort(.internalServerError)
        }
        if !["png","jpg","jpeg","gif"].contains(ext) {
            throw Abort(.init(statusCode: 0, reasonPhrase: "不能上传该文件!"))
        }
        let imageName = try ConstTool.geneImageName(by: file.filename)
            FileManager.default.createFile(atPath: ConstTool.PostImagePath+imageName, contents: file.data, attributes: nil)
        return try ImageResonse<String>(code: 0, msg: "上传成功", data: "upload/"+imageName).encode(for: req)
    }
    
    //模糊查询
    func postAll(_ req: Request,titleFields: GetPostsByTitleRequest) throws -> Future<View> {
        
        print(titleFields)
        
      
        return req.withPooledConnection(to: .mysql) { (conn) in
            return Post.query(on: conn)
                
                   .filter(\Post.title, MySQLBinaryOperator._like, titleFields.title + "%")
//                   .filter(\Post.id, MySQLBinaryOperator._equal, titleFields.categoryId)
//                   .filter(custom: \Post.title ~= titleFields.title)
                   .all()
                   .flatMap { posts in

                    return Category.query(on: conn).all().flatMap {
                        return try req.view().render("postList",PostResponse.init(posts: posts, categories: $0))
                    }
            }
        }
//
        
    }
    
    func postAddGet(_ req: Request) throws -> Future<View> {
        
        if let id =  try? req.parameters.next(Int.self) {
            //修改
            return Post.get(on: req, by: id).flatMap { post in

                print(post)

                return Category.queryAllValue(on: req).flatMap {
                    
                    let postResponse = PostAddResponse.init(post: post, categories: $0.categories)
                    return try req.view().render("postAdd",postResponse)
                }
            }
        }
        
        return Category.queryAllValue(on: req).flatMap {
            return try req.view().render("postAdd",$0)
        }
    }
    func postGet(_ req: Request) throws -> Future<View> {
        
        return  Post.queryAllValue(on: req).flatMap {
            
            print($0.posts)
            print($0.categories.count)
            return try req.view().render("postList",$0)
        }
    }
    
    func postAddPost(_ req: Request,postFields: PostRequest) throws -> Future<View> {
        let post = Post.init(postRequest: postFields)
        return post.add(on: req).flatMap {_ in
            return  Post.queryAllValue(on: req).flatMap {
                return try req.view().render("postList",$0)
            }
        }
    }
    func postEditPost(_ req: Request,postFields: PostRequest) throws -> Future<View> {
        //
        let post = Post.init(postRequest: postFields)
        
        return post.edit(on: req).flatMap {_ in
            return  Post.queryAllValue(on: req).flatMap {
                return try req.view().render("postList",$0)
            }
        }
    }
    //
    func postDelete(_ req: Request) throws -> Future<View> {
        
        return  Post.delete(on: req, by: try req.parameters.next(Int.self))
            .flatMap {
                return  Post.queryAllValue(on: req).flatMap {
                    return try req.view().render("postList",$0)
                }
        }
        
    }
    
    
    
    func categoryAddGet(_ req: Request) throws -> Future<View> {
        
        if let id =  try? req.parameters.next(Int.self) {
            //修改
            return Category.get(on: req, by: id).flatMap {
                return try req.view().render("categoryAdd",$0)
            }
        }
        
        return try req.view().render("categoryAdd")
    }
    func categoryGet(_ req: Request) throws -> Future<View> {

        return  Category.queryAllValue(on: req).flatMap {
            return try req.view().render("categoryList",$0)
        }
    }
    
    func categoryAddPost(_ req: Request,categoryFields: Category) throws -> Future<View> {
        
        return categoryFields.add(on: req).flatMap {_ in
            return  Category.queryAllValue(on: req).flatMap {
                return try req.view().render("categoryList",$0)
            }
        }
    }
    func categoryEditPost(_ req: Request,categoryFields: Category) throws -> Future<View> {
        //
        return categoryFields.edit(on: req).flatMap {_ in
            return  Category.queryAllValue(on: req).flatMap {
                return try req.view().render("categoryList",$0)
            }
        }
    }
    //
    func categoryDelete(_ req: Request) throws -> Future<View> {
        
        return  Category.delete(on: req, by: try req.parameters.next(Int.self))
            .flatMap {
                return  Category.queryAllValue(on: req).flatMap {
                    return try req.view().render("categoryList",$0)
                }
        }
 
    }
    
    
    func logout(_ req: Request) throws -> Future<View> {
        try req.destroySession()
        return try req.view().render("login")
    }
    func loginGet(_ req: Request) throws -> Future<View> {

        
        //这快吧用户id记住就行了
        guard let dataID = try req.session()["userId"]  else {
            return try req.view().render("login")
        }
        //通过dataID 查出所在用户
        return User.query(by: Int(dataID)!, on: req).flatMap{
            //假如用户在
            return try req.view().render("account", $0)
        }
    }
    
    func loginPost(_ req: Request,loginFields: LoginRequest) throws -> Future<View> {
        //获取用户IP地址
        let user =  User(username: loginFields.username,
                         password: loginFields.password,
                           lastIp: req.ip)
        //通过dataID 查出所在用户
        let adminUser = User.init(username: "admin", password: "123456", lastIp: req.ip)
  
        return adminUser.isExist(on: req).flatMap {
            //如果存在-则登录 - 不存在则创建后登录
            if $0 == nil {
                return adminUser.create(on: req).flatMap {
                    return try req.view().render("account", $0)
                }
            }else {
                return try user.login(req).flatMap {
                    return try req.view().render("account", $0)
                }
            }
            
        }
    }
    
    
    func configGet(_ req: Request) throws -> Future<View> {
        
        //这快到时候 放到中间件吧
        
//        print(try req.session().data)
//        //这快吧用户id记住就行了
//        guard let _ = try req.session()["userId"]  else {
//            return try req.view().render("login")
//        }

        //通过dataID 查出这个用户对应这个人的所有配置
        return HomeConfig.query(on: req).first().flatMap{
            //假如用户在
            print($0)
            return try req.view().render("config", $0!)
        }
    }
    //提交配置
    func configPost(_ req: Request,configFields: HomeConfig) throws -> Future<View> {

        return  configFields.updateConfig(on: req).flatMap {
            return try req.view().render("config", $0)
        }
    }
    
    
}

extension Request {
    var ip: String {
        var hostname = self.http.remotePeer.hostname ?? ""
        let port = self.http.remotePeer.port == nil ? "" : "\(self.http.remotePeer.port!)"
        if port.count > 0 {
            hostname = hostname + ":" + port
        }
        return hostname
    }
}
