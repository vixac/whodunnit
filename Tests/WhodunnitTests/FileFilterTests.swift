
import Foundation
import XCTest
@testable import Whodunnit

class Tests: XCTestCase {
    
    func testFileTypes() {
        XCTAssertEqual(FileType.from(filename: "this/this.a/swiftyfile.swift"), FileType.swift)
        XCTAssertEqual(FileType.from(filename: "this/this.a/objc.m"), FileType.objc)
        XCTAssertEqual(FileType.from(filename: "this/this.a/objc.proj"), FileType.unknown)
        XCTAssertEqual(FileType.from(filename: "this/this.a/header.h"), FileType.header)
        XCTAssertEqual(FileType.from(filename: "this/this.a/header.xib"), FileType.xib)
        XCTAssertEqual(FileType.from(filename: "this/this.a/header.storyboard"), FileType.storyboard)
    }
    
    func testFilter() {
        let prefix = "this/is.a/file."
        let fileNames: [String] = ["swift", "xib", "swift", "m", "h", "m", "java"].enumerated().map { index, suffix in
            return "\(index)\(prefix)\(suffix)"
        }
        
        let swiftFiles = FileFilter.keepOnly(types: [.swift], fileNames: fileNames)
        XCTAssertEqual(swiftFiles.count, 2)
        XCTAssertEqual(swiftFiles[0].type, .swift)
        XCTAssertEqual(swiftFiles[1].type, .swift)
        XCTAssertEqual(swiftFiles[0].fullPath.first, "0", "first swift file found should be the first file in the list")
        XCTAssertEqual(swiftFiles[1].fullPath.first, "2", "second swift file found shoul dbe the third file in the list") //
    }
    
}
