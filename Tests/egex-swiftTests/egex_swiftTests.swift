import XCTest
@testable import egex_swift

final class egex_swiftTests: XCTestCase {
    func testFlattenSequence() throws {
        let r: RegexExpression = .concat(.symbol("a"), .concat(.symbol("b"), .symbol("c")))
        let flattenedAST = flattenSequence(r)
        
        XCTAssert(flattenedAST.0 == "abc")
        XCTAssert(flattenedAST.1 == nil)
    }
}
