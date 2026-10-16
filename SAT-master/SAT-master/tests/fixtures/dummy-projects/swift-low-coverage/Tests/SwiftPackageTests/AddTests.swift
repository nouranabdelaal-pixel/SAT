import XCTest
@testable import SwiftPackage

final class AddTests: XCTestCase {
    func testSum() { XCTAssertEqual(sum(1, 2), 3) }
}
