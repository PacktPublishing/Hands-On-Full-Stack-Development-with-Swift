import Vapor

let drop = try Droplet()

drop.get("hello") { (_ req: Request) throws -> ResponseRepresentable in return "Hello, world."
}

drop.get("hello") { (_ req: Request) throws -> ResponseRepresentable in
  return Response(
    status: .ok,
    headers: ["Content-Type": "text/plain; charset=utf-8"],
    body: "Hello, world.".makeBytes()
  )
}

drop.get("welcome/hello/world") { req in
  return "GET request for /welcome/hello/world"
}

drop.get("welcome", "hello", "world") { req in
  return "GET request for /welcome/hello/world"
}

drop.get("hello", String.parameter) { (_ req: Request) throws -> ResponseRepresentable in
 let name = try req.parameters.next(String.self)
 return "Hello \(name)"
}

drop.get("item",":id") { (_ req: Request) throws -> ResponseRepresentable in
  let id = req.parameters["id"]?.int
  return "Requesting Item with id \(id!)"
}

drop.get("item", ":id") { (_ req: Request) throws -> ResponseRepresentable in
  guard let id = req.parameters["id"]?.int else {
    throw Abort.badRequest
  }
  return "Requesting Item with id \(id)"
}

drop.get("welcome", "*") { req in
  return "Welcome"
}

try drop.run()
