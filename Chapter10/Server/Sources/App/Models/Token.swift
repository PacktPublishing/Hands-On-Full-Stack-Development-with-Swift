import Vapor
import FluentProvider
import Crypto

final class Token: Model {
  let storage = Storage()
  var token: String
  var userId: Identifier
  var user: Parent<Token, User> {
    return parent(id: userId)
  }
  
  struct Keys {
    static let id = "id"
    static let token = "token"
    static let userId = "user__id"
  }
  
  init(string: String, user: User) throws {
    token = string
    userId = try user.assertExists()
  }
  
  init(row: Row) throws {
    token = try row.get(Keys.token)
    userId = try row.get(Keys.userId)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.token, token)
    try row.set(Keys.userId, userId)
    return row
  }
  
  static func generate(for user: User) throws -> Token {
    let random = try Crypto.Random.bytes(count: 16)
    
    return try Token(string: random.base64Encoded.makeString(), user: user)
  }
}

extension Token: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(Keys.token)
      builder.parent(User.self)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Token: JSONRepresentable {
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("token", token)
    return json
  }
}

extension Token: ResponseRepresentable { }
