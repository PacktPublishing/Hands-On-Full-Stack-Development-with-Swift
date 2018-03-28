import Vapor

let drop = try Droplet()

drop.get("hello") { req in
  return "Hello, world."
}

try drop.run()
