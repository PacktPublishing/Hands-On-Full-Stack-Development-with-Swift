import Transport
import HTTP
import WebSockets

class WebSocketResponder: Responder {
    func respond(to request: Request) throws -> Response {
        return try request.upgradeToWebSocket { ws in
            try ws.send("Hello from web socket!")
            
            ws.onText = { ws, text in
                try ws.send("Got message: \(text)")
            }
        }
    }
}

let PORT = Port(5000)
let server = try BasicServer(scheme: "http", hostname: "0.0.0.0", port: PORT)

print("Started on port \(PORT)")
try server.start(WebSocketResponder()) { error in
    print(error)
}
