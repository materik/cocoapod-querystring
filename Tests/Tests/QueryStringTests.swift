
import XCTest

@testable import QueryString

class QueryStringTests: XCTestCase {
    
    func testNoQuery() {
        let qs = QueryString()
        XCTAssertEqual(qs.description, "")
        XCTAssertEqual(qs.append(to: "user/123"), "user/123")
    }
    
    func testOneQuery() {
        var qs = QueryString()
        qs.add(key: "query", value: "xxx")
        XCTAssertEqual(qs.description, "query=xxx")
        XCTAssertEqual(qs.append(to: "user/123"), "user/123?query=xxx")
    }
    
    func testTwoQueries() {
        var qs = QueryString()
        qs.add(key: "query", value: "xxx")
        qs.add(key: "another", value: "yyy")
        XCTAssertEqual(qs.description, "another=yyy&query=xxx")
    }
    
    func testSpace() {
        var qs = QueryString()
        qs.add(key: "query", value: "xx x")
        XCTAssertEqual(qs.description, "query=xx%20x")
    }
    
    func testSpecialCharacters() {
        var qs = QueryString()
        qs.add(key: "redirect", value: "zmartaapp://")
        XCTAssertEqual(qs.description, "redirect=zmartaapp://")
    }
    
    func testWithPathAlreadyContainingQuestionMark() {
        var qs = QueryString()
        qs.add(key: "query", value: "xxx")
        XCTAssertEqual(qs.append(to: "user/123?"), "user/123?query=xxx")
        XCTAssertEqual(qs.append(to: "user/123?another=yyy"), "user/123?another=yyy&query=xxx")
    }
    
}
