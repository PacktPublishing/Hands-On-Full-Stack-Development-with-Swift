final class ShoppingListController: BaseResourceController<ShoppingList> {
  override func index(_ req: Request) throws -> ResponseRepresentable {
    let response = Response(status: .ok)
    let user = try req.user()
    let resources = try ShoppingList.makeQuery().filter(ShoppingList.Keys.userId, user.id).all()
    response.resources = resources
    return response
  }
  
  override func store(_ req: Request) throws -> ResponseRepresentable {
    let response = Response(status: .ok)
    guard let json = req.json else { throw Abort.badRequest }
    let user = try req.user()
    let list = try ShoppingList(json: json)
    list.userId = user.id!
    try list.save()
    response.resource = list
    return response
  }
}
