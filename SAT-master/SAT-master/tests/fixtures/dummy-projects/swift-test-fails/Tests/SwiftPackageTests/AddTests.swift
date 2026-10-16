import XCTest
@testable import SwiftPackage

final class AddTests: XCTestCase {
    func testSum() { XCTAssertEqual(sum(1, 2), 4) }
    func testTwice() { XCTAssertEqual(unusedTimesTwo(2), 4) }
}
