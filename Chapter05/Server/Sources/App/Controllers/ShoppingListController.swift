import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// RESTful interactions with our ShoppingLists table
final class ShoppingListController: ResourceRepresentable {
  /// When users call 'GET' on '/ShoppingLists'
  /// it should return an index of all available ShoppingLists
  func index(_ req: Request) throws -> ResponseRepresentable {
    return try ShoppingList.all().makeJSON()
  }
  
  /// When consumers call 'POST' on '/ShoppingLists' with valid JSON
  /// construct and save the ShoppingList
  func store(_ req: Request) throws -> ResponseRepresentable {
    let shoppingList = try req.shoppingList()
    try shoppingList.save()
    return shoppingList
  }
  
  /// When the consumer calls 'GET' on a specific resource, ie:
  /// '/ShoppingLists/13rd88' we should show that specific ShoppingList
  func show(_ req: Request, shoppingList: ShoppingList) throws -> ResponseRepresentable {
    return shoppingList
  }
  
  /// When the consumer calls 'DELETE' on a specific resource, ie:
  /// 'ShoppingLists/l2jd9' we should remove that resource from the database
  func delete(_ req: Request, shoppingList: ShoppingList) throws -> ResponseRepresentable {
    try shoppingList.delete()
    return Response(status: .ok)
  }
  
  /// When the consumer calls 'DELETE' on the entire table, ie:
  /// '/ShoppingLists' we should remove the entire table
  func clear(_ req: Request) throws -> ResponseRepresentable {
    try ShoppingList.makeQuery().delete()
    return Response(status: .ok)
  }
  
  /// When the user calls 'PATCH' on a specific resource, we should
  /// update that resource to the new values.
  func update(_ req: Request, shoppingList: ShoppingList) throws -> ResponseRepresentable {
    // See `extension ShoppingList: Updateable`
    try shoppingList.update(for: req)
    
    // Save an return the updated ShoppingList.
    try shoppingList.save()
    return shoppingList
  }
  
  /// When a user calls 'PUT' on a specific resource, we should replace any
  /// values that do not exist in the request with null.
  /// This is equivalent to creating a new ShoppingList with the same ID.
  func replace(_ req: Request, shoppingList: ShoppingList) throws -> ResponseRepresentable {
    // First attempt to create a new ShoppingList from the supplied JSON.
    // If any required fields are missing, this request will be denied.
    let new = try req.shoppingList()
    
    shoppingList.name = new.name
    try shoppingList.save()
    
    return shoppingList
  }
  
  /// When making a controller, it is pretty flexible in that it
  /// only expects closures, this is useful for advanced scenarios, but
  /// most of the time, it should look almost identical to this
  /// implementation
  func makeResource() -> Resource<ShoppingList> {
    return Resource(
      index: index,
      store: store,
      show: show,
      update: update,
      replace: replace,
      destroy: delete,
      clear: clear
    )
  }
}

extension Request {
  /// Create a ShoppingList from the JSON body
  /// return BadRequest error if invalid
  /// or no JSON
  func shoppingList() throws -> ShoppingList {
    guard let json = json else { throw Abort.badRequest }
    return try ShoppingList(json: json)
  }
}
