import Vapor
import AuthProvider
import Sessions

extension Droplet {
  func setupRoutes() throws {
    self.setupUnauthenticatedRoutes()
    self.setupAuthenticatedRoutes()
  }
  
  func setupUnauthenticatedRoutes() {
    post("register") { req in
      guard let form = req.formURLEncoded,
        let name = form["name"]?.string,
        !name.isEmpty,
        let email = form["email"]?.string,
        !email.isEmpty,
        let password = form["password"]?.string,
        !password.isEmpty else {
          throw Abort(.badRequest)
      }
      
      guard try User.makeQuery().filter("email", email).first() == nil else {
        throw Abort(.badRequest, reason: "A user with that email already exists.")
      }
      
      let encryptedPassword = try self.hash.make(password.makeBytes()).makeString()
      let user = User(name: name, email: email, password: encryptedPassword)
      try user.save()
      
      return "User Account Created Successfully"
    }
  }
  
  func setupAuthenticatedRoutes() {
    let passwordMiddleware = PasswordAuthenticationMiddleware(User.self)
    let memory = MemorySessions()
    let persistMiddleware = PersistMiddleware(User.self)
    let sessionsMiddleware = SessionsMiddleware(memory)
    let redirect = RedirectMiddleware.login(path: "/")
    let shoppingListController = ShoppingListController()
    let itemController = ItemController()
    
    // Route to
    let loginRoutes = grouped([sessionsMiddleware, persistMiddleware])
    loginRoutes.get() { req in
      if req.auth.isAuthenticated(User.self) {
        return Response(redirect: "/shopping_lists")
      }
      return try self.view.make("welcome")
    }
    loginRoutes.post("login") { req in
      guard let email =  req.formURLEncoded?["email"]?.string,
        let password =  req.formURLEncoded?["password"]?.string else {
          throw Abort(.badRequest)
      }
      let credentials = Password(username: email, password: password)
      let user = try User.authenticate(credentials)
      req.auth.authenticate(user)
      return Response(redirect: "/shopping_lists")
    }
    
    // Routes for Web
    let authRoutes = grouped([redirect, sessionsMiddleware, persistMiddleware, passwordMiddleware])
    authRoutes.resource("shopping_lists", shoppingListController)
    authRoutes.resource("items", itemController)
    authRoutes.get("logout") { req in
      try req.auth.unauthenticate()
      return Response(redirect: "/")
    }
    
    let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
    let tokenAuthRoutes = grouped(tokenMiddleware)
    tokenAuthRoutes.resource("api/shopping_lists", shoppingListController)
    tokenAuthRoutes.resource("api/items", itemController)
    
    // Route to get Token after authentication
    grouped(passwordMiddleware)
      .post("api/tokens") { req in
        let user = try req.user()
        let existingToken = try Token.makeQuery().filter(Token.Keys.userId, user.id).first()
        let token = try Token.generate(for: user)
        try token.save()
        try existingToken?.delete()
        return token
    }
  }
}
