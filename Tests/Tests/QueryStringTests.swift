
import XCTest

@testable import QueryString

class QueryStringTests: XCTestCase {
    
    func testNoQuery() {
        let qs = QueryString()
        XCTAssertEqual(qs.description, "")
        XCTAssertEqual(qs.append(to: "user/123"), "user/123")
    }
    
    func testOneQuery() {
        let qs = QueryString(key: "query", value: "xxx")
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
    
    func testPathEmpty() {
        var url1 = ""
        XCTAssertNil(QueryString(url: &url1))
        XCTAssertEqual(url1, "")
        var url2 = "user/123?"
        XCTAssertNil(QueryString(url: &url2))
        XCTAssertEqual(url2, "user/123")
        var url3 = "user/123??x=1"
        XCTAssertNil(QueryString(url: &url3))
        XCTAssertEqual(url3, "user/123??x=1")
    }
    
    func testPathWithOneQuery() {
        let qs = QueryString(url: "user/123?another=yyy")
        XCTAssertEqual(qs?.description, "another=yyy")
    }
    
    func testPathWithTwoQueries() {
        let qs = QueryString(url: "user/123?another=yyy&query=xxx")
        XCTAssertEqual(qs?.description, "another=yyy&query=xxx")
    }
    
    func testStripPath() {
        var url = "user/123?query=xxx"
        let qs = QueryString(url: &url)
        XCTAssertEqual(url, "user/123")
        XCTAssertEqual(qs?.description, "query=xxx")
    }
    
    func testString() {
        let qs1 = QueryString(string: "another=yyy")
        XCTAssertEqual(qs1?.description, "another=yyy")
        let qs2 = QueryString(string: "another=yyy&query=xxx")
        XCTAssertEqual(qs2?.description, "another=yyy&query=xxx")
    }
    
}
