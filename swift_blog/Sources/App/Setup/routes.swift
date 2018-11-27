import Vapor
import MySQL
/// Register your application's routes here.
public func routes(_ router: Router,_ container: Container) throws {
    //首页
//    try router.register(collection: HomeController(db: container.connectionPool(to: .mysql)))
    try router.register(collection: HomeController())
//    let authRouter = router.grouped(AuthMiddleware())
    try router.register(collection: AuthController())
    // "It works" page
//    router.get { req in
//        return try req.view().render("welcome")
//    }
//
//    // Says hello
//    router.get("hello", String.parameter) { req -> Future<View> in
//        return try req.view().render("hello", [
//            "name": req.parameters.next(String.self)
//        ])
//    }
}
