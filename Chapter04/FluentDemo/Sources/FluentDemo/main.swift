import Fluent

let driver = try SQLiteDriver(path: "main.sqlite")
let database = Database(driver)

final class ShoppingList: Entity {
    var name: String
    let storage = Storage()
    var items: Children<ShoppingList, Item> {
        return children()
    }

    init(name: String) {
        self.name = name
    }

    init(row: Row) throws {
        name = try row.get("name")
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        return row
    }
}

extension ShoppingList: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { list in
            list.id()
            list.string("name")
        }
    } 

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

final class Item: Entity {
    var name: String
    var isChecked: Bool
    var shoppingListId: Identifier
    let storage = Storage()
    var list: Parent<Item, ShoppingList> {
        return parent(id: shoppingListId)
    }

    init(name: String, shoppingListId: Identifier, isChecked: Bool = false) {
        self.name = name
        self.isChecked = isChecked
        self.shoppingListId = shoppingListId
    }

    init(row: Row) throws {
        name = try row.get("name")
        isChecked = try row.get("is_checked")
        shoppingListId = try row.get("shopping_list_id")
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("is_checked", isChecked)
        try row.set("shopping_list_id", shoppingListId)
        return row
    }
}

extension Item: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { items in
            items.id()
            items.string("name")
            items.bool("is_checked")
            items.parent(ShoppingList.self)
        }
    } 

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

Item.database = database


try database.prepare([Item.self, ShoppingList.self])

ShoppingList.database = database

let list = ShoppingList(name: "Groceries")
try list.save()
["Apple", "Banana"].forEach {
    let item = Item(name: $0, shoppingListId: list.id!)
    try! item.save()
}

let groceriesList = try ShoppingList.makeQuery().filter("name", "Groceries").first()!
let allItemsInGroceriesList = try groceriesList.items.all()
let appleItem = try groceriesList.items.filter("name", "Apple").first()!
print(appleItem.name)
