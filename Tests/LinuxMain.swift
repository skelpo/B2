import XCTest

import B2Tests

var tests = [XCTestCaseEntry]()
tests += B2Tests.allTests()
XCTMain(tests)