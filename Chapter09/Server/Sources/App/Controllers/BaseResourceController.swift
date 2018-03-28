import FluentProvider

protocol Replaceable {
  func replaceAttributes(from: Self) -> Void
}

class BaseResourceController<T: Model & JSONConvertible & Updateable & Replaceable>: ResourceRepresentable {
  func index(_ req: Request) throws -> ResponseRepresentable {
    let response = Response(status: .ok)
    let resources = try T.all()
    response.resources = resources
    return response
  }
  
  func store(_ req: Request) throws -> ResponseRepresentable {
    let response = Response(status: .ok)
    guard let json = req.json else { throw Abort.badRequest }
    let resource = try T(json: json)
    try resource.save()
    response.resource = resource
    return response
  }
  
  func show(_ req: Request, resource: T) throws -> ResponseRepresentable {
    let response = Response(status: .ok)
    response.resource = resource
    return response
  }
  
  func delete(_ req: Request, resource: T) throws -> ResponseRepresentable {
    try resource.delete()
    return Response(status: .ok)
  }
  
  func clear(_ req: Request) throws -> ResponseRepresentable {
    try T.makeQuery().delete()
    return Response(status: .ok)
  }
  
  func update(_ req: Request, resource: T) throws -> ResponseRepresentable {
    let response = Response(status: .ok)
    try resource.update(for: req)
    try resource.save()
    response.resource = resource
    return response
  }
  
  func replace(_ req: Request, resource: T) throws -> ResponseRepresentable {
    let response = Response(status: .ok)
    guard let json = req.json else { throw Abort.badRequest }
    let new = try T(json: json)
    resource.replaceAttributes(from: new)
    try resource.save()
    response.resource = resource
    return response
  }
  
  func makeResource() -> Resource<T> {
    return Resource(
      index: index,
      store: store,
      show: show,
      update: update,
      replace: replace,
      destroy: delete,
      clear: clear
    )
  }
}
