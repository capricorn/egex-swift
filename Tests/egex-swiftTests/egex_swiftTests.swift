import XCTest
@testable import egex_swift

final class egex_swiftTests: XCTestCase {
    func testFlattenSequence() throws {
        let r: RegexExpression = .concat(.symbol("a"), .concat(.symbol("b"), .symbol("c")))
        let flattenedAST = flattenSequence(r)
        
        XCTAssert(flattenedAST.0 == "abc")
        XCTAssert(flattenedAST.1 == nil)
    }
    
    func testFlattenASTTest() throws {
        let r: RegexExpression = .quantifier(.concat(.symbol("a"), .concat(.symbol("b"), .symbol("c"))), .zeroOrMore)
        
        print("\(r)")
        // TODO: Flattened AST equality for test
        let flattenedAST = flatten(r)
        print("\(flattenedAST)")
        
        // TODO: Assertion
    }
    
    func testFlattenASTTestComplex() throws {
        let r: RegexExpression = .union(.quantifier(.concat(.symbol("a"), .concat(.symbol("b"), .symbol("c"))), .zeroOrMore), .quantifier(.concat(.symbol("x"), .concat(.symbol("y"), .symbol("z"))), .zeroOrMore))
        
        print("\(r)")
        // TODO: Flattened AST equality for test
        let flattenedAST = flatten(r)
        print("\(flattenedAST)")
        // TODO: Assertion
    }
}
