import FluentProvider

extension Response {
  var resource: (Model & JSONConvertible)? {
    get {
      return storage["resource"] as? (Model & JSONConvertible)
    }
    set(resource) {
      storage["resource"] = resource
    }
  }
  
  var resources: [(Model & JSONRepresentable)]? {
    get {
      return storage["resources"] as? [(Model & JSONRepresentable)]
    }
    set(resources) {
      storage["resources"] = resources
    }
  }
}

public class ResponseFormatterMiddleware: Middleware {
  let viewRenderer: ViewRenderer
  
  public init(config: Config) throws {
    self.viewRenderer = try config.resolveView()
  }
  
  public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    let response = try next.respond(to: request)
    if let resource = response.resource {
      if request.accept.prefers("html") {
        let resourceName = type(of: resource).name
        return try viewRenderer.make(resourceName, [
          "\(resourceName)": resource.makeJSON()
          ]).makeResponse()
      } else {
        return try resource.makeJSON().makeResponse()
      }
    } else if let resources = response.resources {
      if request.accept.prefers("html") {
        let resourcesName = request.uri.lastPathComponent!
        return try viewRenderer.make(resourcesName, [
          "\(resourcesName)": resources.map({ try $0.makeJSON() })
        ]).makeResponse()
      } else {
        return try JSON(resources.map({ try $0.makeJSON().wrapped })).makeResponse()
      }
    }
    
    return response
  }
}
