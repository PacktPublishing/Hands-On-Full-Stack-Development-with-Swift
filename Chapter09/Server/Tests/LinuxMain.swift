#if os(Linux)

import XCTest
@testable import AppTests

XCTMain([
    // AppTests
    testCase(ShoppingListControllerTests.allTests),
    testCase(RouteTests.allTests)
])

#endif
