import Vapor
import FluentProvider
import HTTP

final class ShoppingList: Model {
  let storage = Storage()
  // MARK: Properties and database keys
  
  var name: String
  var userId: Identifier
  var items: Children<ShoppingList, Item> {
    return children()
  }
  var user: Parent<ShoppingList, User> {
    return parent(id: userId)
  }
  
  struct Keys {
    static let id = "id"
    static let name = "name"
    static let userId = "user__id"
  }
  
  /// Creates a new ShoppingList
  init(name: String, userId: Identifier) {
    self.name = name
    self.userId = userId
  }
  
  // MARK: Fluent Serialization
  
  /// Initializes the ShoppingList from the
  /// database row
  init(row: Row) throws {
    name = try row.get(ShoppingList.Keys.name)
    userId = try row.get(ShoppingList.Keys.userId)
  }
  
  // Serializes the ShoppingList to the database
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(ShoppingList.Keys.name, name)
    try row.set(ShoppingList.Keys.userId, userId)
    return row
  }
}

// MARK: Fluent Preparation

extension ShoppingList: Preparation {
  /// Prepares a table/collection in the database
  /// for storing ShoppingLists
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(ShoppingList.Keys.name)
      builder.parent(User.self)
    }
  }
  
  /// Undoes what was done in `prepare`
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new ShoppingList (POST /ShoppingLists)
//     - Fetching a ShoppingList (GET /ShoppingLists, GET /ShoppingLists/:id)
//
extension ShoppingList: JSONConvertible {
  convenience init(json: JSON) throws {
    self.init(
      name: try json.get(ShoppingList.Keys.name),
      userId: try json.get(ShoppingList.Keys.userId)
    )
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(ShoppingList.Keys.id, id)
    try json.set(ShoppingList.Keys.name, name)
    try json.set("items", items.all())
    try json.set(ShoppingList.Keys.userId, userId)
    return json
  }
}

extension ShoppingList: Replaceable {
  func replaceAttributes(from list: ShoppingList) {
    self.name = list.name
    self.userId = list.userId
  }
}


// MARK: HTTP

// This allows ShoppingList models to be returned
// directly in route closures
extension ShoppingList: ResponseRepresentable { }

// MARK: Update

// This allows the ShoppingList model to be updated
// dynamically by the request.
extension ShoppingList: Updateable {
  // Updateable keys are called when `ShoppingList.update(for: req)` is called.
  // Add as many updateable keys as you like here.
  public static var updateableKeys: [UpdateableKey<ShoppingList>] {
    return [
      // If the request contains a String at key "name"
      // the setter callback will be called.
      UpdateableKey(ShoppingList.Keys.name, String.self) { shoppingList, name in
        shoppingList.name = name
      }
    ]
  }
}

