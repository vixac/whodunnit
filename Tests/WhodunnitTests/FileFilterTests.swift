
import Foundation
import XCTest
@testable import Whodunnit

class Tests: XCTestCase {
    func testFileTypes(){
    
        XCTAssertEqual(FileType.from(filename: "this/this.a/swiftyfile.swift"), FileType.swift)
        XCTAssertEqual(FileType.from(filename: "this/this.a/objc.m"), FileType.objc)
        XCTAssertEqual(FileType.from(filename: "this/this.a/objc.proj"), FileType.unknown)
        XCTAssertEqual(FileType.from(filename: "this/this.a/header.h"), FileType.header)
        XCTAssertEqual(FileType.from(filename: "this/this.a/header.xib"), FileType.xib)
        XCTAssertEqual(FileType.from(filename: "this/this.a/header.storyboard"), FileType.storyboard)
        
    }
    
}
