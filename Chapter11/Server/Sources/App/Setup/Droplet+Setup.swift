@_exported import Vapor
import AuthProvider

extension Droplet {
  public func setup() throws {
    try setupRoutes()
    try setupPasswordVerifier()
  }
  private func setupPasswordVerifier() throws {
    guard let verifier = hash as? PasswordVerifier else {
      throw Abort(.internalServerError, reason: "\(type(of: hash)) must conform to PasswordVerifier.")
    }
    User.passwordVerifier = verifier
  }
}
