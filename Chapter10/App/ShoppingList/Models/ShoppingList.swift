import Foundation

class ShoppingList: Codable {
  var id: String?
  var name: String
  var items: [Item]
  var data: Data? {
    get {
      let parameters = ["name": name] as [String : Any]
      do {
        return try JSONSerialization.data(withJSONObject: parameters, options: [])
      } catch {
        return .none
      }
    }
  }
  
  init(name: String, items: [Item] = []) {
    self.name = name
    self.items = items
  }
  
  static func load(onCompletion: @escaping ([ShoppingList]) -> Void) {
    request(url: "/shopping_lists") { data, response, error in
      let decoder = JSONDecoder()
      let shoppingLists = try decoder.decode([ShoppingList].self, from: data!)
      onCompletion(shoppingLists)
    }
  }
  
  func save(onCompletion: @escaping (ShoppingList) -> Void) {
    request(url: "/shopping_lists", httpMethod: "POST", httpBody: data) { data, _, _ in
      let decoder = JSONDecoder()
      let list = try decoder.decode(ShoppingList.self, from: data!)
      onCompletion(list)
    }
  }
  
  func delete(onCompletion: @escaping () -> Void) {
    request(url: "/shopping_lists/\(id!)", httpMethod: "DELETE") { data, _, _ in
      onCompletion()
    }
  }
  
  func add(_ item: Item, onCompletion: @escaping () -> Void) {
    request(url: "/items/", httpMethod: "POST", httpBody: item.data) { data, response, error in
      let decoder = JSONDecoder()
      let item = try decoder.decode(Item.self, from: data!)
      self.items.append(item)
      onCompletion()
    }
  }
  
  func remove(at index: Int, onCompletion: @escaping () -> Void) {
    let itemId = self.items[index].id!
    request(url: "/items/\(itemId)", httpMethod: "DELETE") { _, _, _ in
      self.items.remove(at: index)
      onCompletion()
    }
  }
  
  func swapItem(_ fromIndex: Int, _ toIndex: Int) {
    self.items.swapAt(fromIndex, toIndex)
  }
  
  func toggleCheckItem(atIndex index: Int, onCompletion: @escaping (Item) -> Void) {
    self.items[index].toggleCheck(onCompletion: onCompletion)
  }
  
  func description() -> String {
    return name
  }
  
  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case items
  }
}

