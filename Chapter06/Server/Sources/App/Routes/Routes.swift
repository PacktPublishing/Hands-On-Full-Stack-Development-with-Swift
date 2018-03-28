import Vapor

extension Droplet {
  func setupRoutes() throws {
    resource("shopping_lists", ShoppingListController())
    resource("items", ItemController())
  }
}
