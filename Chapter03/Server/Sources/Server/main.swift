import Transport
import HTTP
import Foundation

let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

extension NSData {
  var toBytes: Bytes {
    get {
      return Bytes(UnsafeBufferPointer(start: bytes.assumingMemoryBound(to: UInt8.self), count: length))
    }
  }
}

class FileResponder: Responder {
  func respond(to request: Request) throws -> Response {
    let fileURL = currentDirectoryURL.appendingPathComponent(request.uri.path)
    if let data = NSData(contentsOf: fileURL) {
      return Response(status: .ok, body: data.toBytes)
    }
    return Response(status: .notFound)
  }
}

let PORT = Port(5000)
let server = try BasicServer(scheme: "http", hostname: "0.0.0.0", port: PORT)

print("Started on port \(PORT)")
try server.start(FileResponder()) { error in
  print(error)
}
