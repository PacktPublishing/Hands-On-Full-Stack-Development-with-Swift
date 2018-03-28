import XCTest
import Foundation
import Testing
import HTTP
@testable import Vapor
@testable import App

/// This file shows an example of testing 
/// routes through the Droplet.

class RouteTests: TestCase {
  let drop = try! Droplet.testable()
  
  func testHealthcheck() throws {
    try drop
      .testResponse(to: .get, at: "healthcheck.html")
      .assertStatus(is: .ok)
      .assertJSON("status", equals: "up")
  }
  
  func testRootRoute() throws {
    try drop
      .testResponse(to: .get, at: "/")
      .assertStatus(is: .seeOther)
      .assertHeader("Location", contains: "/shopping_lists")
  }

  static let allTests = [
    ("testHealthcheck", testHealthcheck),
    ("testRootRoute", testRootRoute),
    ]
}
