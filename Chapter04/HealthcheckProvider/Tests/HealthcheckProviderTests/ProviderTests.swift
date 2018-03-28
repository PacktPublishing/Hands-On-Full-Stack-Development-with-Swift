@testable import Vapor
@testable import HealthcheckProvider
import XCTest
import Testing

extension Droplet {
  static func testable() throws -> Droplet {
    var config = try Config(arguments: ["vapor", "--env=test"])
    try! config.set("healthcheck.url", "healthcheck")
    try! config.addProvider(HealthcheckProvider.Provider.self)
    return try Droplet(config)
  }
  func serveInBackground() throws {
    background {
      try! self.run()
    }
    console.wait(seconds: 0.5)
  }
}

class ProviderTests: XCTestCase {
  let drop = try! Droplet.testable()

  override func setUp() {
    Testing.onFail = XCTFail
  }

  func testHealthcheck() {
    try! drop
      .testResponse(to: .get, at: "healthcheck")
      .assertStatus(is: .ok)
      .assertJSON("status", equals: "up")
  }


  static var allTests = [
    ("testHealthcheck", testHealthcheck),
  ]
}
