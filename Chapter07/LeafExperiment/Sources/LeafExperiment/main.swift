import Vapor
import Leaf

let stem = Stem(DataFile(workDir: "./"))
let drop = try Droplet()

drop.get("hello", ":name") { req in
  guard let name = req.parameters["name"]?.string else {
    throw Abort.badRequest
  }
  let leaf = try stem.spawnLeaf(at: "hello")
  let context = Context(["name": Node(name)])
  let rendered = try stem.render(leaf, with: context)
  let response = Response(status: .ok, body: rendered)
  response.headers["content-type"] = "text/html"
  return response
}

try drop.run()
