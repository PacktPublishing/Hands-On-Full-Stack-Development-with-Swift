import Vapor
import FluentProvider
import HTTP

final class Item: Model {
  let storage = Storage()
  
  // MARK: Properties and database keys
  
  var name: String
  var isChecked: Bool
  var shoppingListId: Identifier
  
  var list: Parent<Item, ShoppingList> {
    return parent(id: shoppingListId)
  }
  
  struct Keys {
    static let id = "id"
    static let name = "name"
    static let isChecked = "is_checked"
    static let shoppingListId = "shopping_list__id"
  }
  
  /// Creates a new Item
  init(name: String, shoppingListId: Identifier, isChecked: Bool = false) {
    self.name = name
    self.isChecked = isChecked
    self.shoppingListId = shoppingListId
  }
  
  // MARK: Fluent Serialization
  
  /// Initializes the Item from the
  /// database row
  init(row: Row) throws {
    name = try row.get(Item.Keys.name)
    isChecked = try row.get(Item.Keys.isChecked)
    shoppingListId = try row.get(Item.Keys.shoppingListId)
  }
  
  // Serializes the Item to the database
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Item.Keys.name, name)
    try row.set(Item.Keys.isChecked, isChecked)
    try row.set(Item.Keys.shoppingListId, shoppingListId)
    return row
  }
}

extension Item: Replaceable {
  func replaceAttributes(from item: Item) {
    self.name = item.name
    self.isChecked = item.isChecked
    self.shoppingListId = item.shoppingListId
  }
}

// MARK: Fluent Preparation

extension Item: Preparation {
  /// Prepares a table/collection in the database
  /// for storing Items
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(Item.Keys.name)
      builder.bool(Item.Keys.isChecked)
      builder.parent(ShoppingList.self)
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
//     - Creating a new Item (POST /items)
//     - Fetching a item (GET /items, GET /items/:id)
//
extension Item: JSONConvertible {
  convenience init(json: JSON) throws {
    self.init(
      name: try json.get(Item.Keys.name),
      shoppingListId: try json.get(Item.Keys.shoppingListId),
      isChecked: try json.get(Item.Keys.isChecked)
    )
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Item.Keys.id, id)
    try json.set(Item.Keys.name, name)
    try json.set(Item.Keys.isChecked, isChecked)
    try json.set(Item.Keys.shoppingListId, shoppingListId)
    return json
  }
}

// MARK: HTTP

// This allows Item models to be returned
// directly in route closures
extension Item: ResponseRepresentable { }

// MARK: Update

// This allows the Item model to be updated
// dynamically by the request.
extension Item: Updateable {
  // Updateable keys are called when `item.update(for: req)` is called.
  // Add as many updateable keys as you like here.
  public static var updateableKeys: [UpdateableKey<Item>] {
    return [
      // If the request contains a String at key "name"
      // the setter callback will be called.
      UpdateableKey(Item.Keys.name, String.self) { item, name in
        item.name = name
      },
      UpdateableKey(Item.Keys.isChecked, Bool.self) { item, isChecked in
        item.isChecked = isChecked
      },
      UpdateableKey(Item.Keys.shoppingListId, Identifier.self) { item, shoppingListId in
        item.shoppingListId = shoppingListId
      }
    ]
  }
}
