import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// RESTful interactions with our Items table
final class ItemController: ResourceRepresentable {
  /// When users call 'GET' on '/items'
  /// it should return an index of all available items
  func index(_ req: Request) throws -> ResponseRepresentable {
    return try Item.all().makeJSON()
  }
  
  /// When consumers call 'POST' on '/items' with valid JSON
  /// construct and save the item
  func store(_ req: Request) throws -> ResponseRepresentable {
    let item = try req.item()
    try item.save()
    return item
  }
  
  /// When the consumer calls 'GET' on a specific resource, ie:
  /// '/items/13rd88' we should show that specific item
  func show(_ req: Request, item: Item) throws -> ResponseRepresentable {
    return item
  }
  
  /// When the consumer calls 'DELETE' on a specific resource, ie:
  /// 'items/l2jd9' we should remove that resource from the database
  func delete(_ req: Request, item: Item) throws -> ResponseRepresentable {
    try item.delete()
    return Response(status: .ok)
  }
  
  /// When the consumer calls 'DELETE' on the entire table, ie:
  /// '/items' we should remove the entire table
  func clear(_ req: Request) throws -> ResponseRepresentable {
    try Item.makeQuery().delete()
    return Response(status: .ok)
  }
  
  /// When the user calls 'PATCH' on a specific resource, we should
  /// update that resource to the new values.
  func update(_ req: Request, item: Item) throws -> ResponseRepresentable {
    // See `extension Item: Updateable`
    try item.update(for: req)
    
    // Save an return the updated item.
    try item.save()
    return item
  }
  
  /// When a user calls 'PUT' on a specific resource, we should replace any
  /// values that do not exist in the request with null.
  /// This is equivalent to creating a new Item with the same ID.
  func replace(_ req: Request, item: Item) throws -> ResponseRepresentable {
    // First attempt to create a new Item from the supplied JSON.
    // If any required fields are missing, this request will be denied.
    let new = try req.item()
    
    // Update the item with all of the properties from
    // the new item
    item.name = new.name
    item.isChecked = new.isChecked
    try item.save()
    
    // Return the updated item
    return item
  }
  
  /// When making a controller, it is pretty flexible in that it
  /// only expects closures, this is useful for advanced scenarios, but
  /// most of the time, it should look almost identical to this 
  /// implementation
  func makeResource() -> Resource<Item> {
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
  /// Create a item from the JSON body
  /// return BadRequest error if invalid 
  /// or no JSON
  func item() throws -> Item {
    guard let json = json else { throw Abort.badRequest }
    return try Item(json: json)
  }
}
