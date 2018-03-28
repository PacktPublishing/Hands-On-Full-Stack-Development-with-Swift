import Transport
import HTTP

class Hello: Responder {
  func respond(to request: Request) throws -> Response {
    return "Hello World".makeResponse()
  }
}

let PORT = Port(5000)
let server = try BasicServer(scheme: "http", hostname: "0.0.0.0", port: PORT)

print("Started on port \(PORT)")
try server.start(Hello()) { error in
  print(error)
}

