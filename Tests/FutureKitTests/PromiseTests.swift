import XCTest
@testable import FutureKit

class FutureKitTests: XCTestCase {
    
    /// test handler
    func testHandler() {
        let promise = Promise<Int>()
        var result = 0
        promise.then { $0 + 1 }
                .then { result = $0 }
        promise.setResult(10)
        XCTAssertEqual(11, result)
    }
}
