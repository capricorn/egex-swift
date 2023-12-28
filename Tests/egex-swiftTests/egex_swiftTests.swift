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
    
    func testPartialString() throws {
        let r = partialString("abc")
        
        print("\(r)")
    }
    
    func testPartialAST() throws {
        // TODO: Compose a regex with derivatives, flatten it, partialize it
        let r: FlatRegexAST = .quantifier(.sequence("abc"), .zeroOrMore)
        
        print("\(partial(r))")
    }
    
    func testPhiMatch() throws {
        let d = D("a") .. D("b") .. D("c")
        
        // An example of isolating derivatives after composition
        let matcher = { (input: String) in
            d(String(phi) + input)
        }
        
        XCTAssert(matcher("abc").0 == nil)
        XCTAssert(matcher("bc").0 == "")
    }
}
