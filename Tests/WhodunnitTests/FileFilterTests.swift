
import Foundation
import XCTest
@testable import WhodunnitLib

class FiltFilterTests: XCTestCase {
    
    func testFileTypes() {
        XCTAssertEqual(FileNameSummary(fullPath: "this/this.a/swiftyfile.swift").suffix, "swift")
        XCTAssertEqual(FileNameSummary(fullPath: "this/this.a/objc.m").suffix, "m")
        XCTAssertEqual(FileNameSummary(fullPath: "this/this.a/objc.proj").suffix, "proj")
        XCTAssertEqual(FileNameSummary(fullPath: "this/this.a/header.h").suffix, "h")
        XCTAssertEqual(FileNameSummary(fullPath: "this/this.a/header.xib").suffix, "xib")
        XCTAssertEqual(FileNameSummary(fullPath: "this/this.a/header.storyboard").suffix, "storyboard")
    }
    
    func testFilter() {
        let prefix = "this/is.a/file."
        let fileNames: [String] = ["swift", "xib", "swift", "m", "h", "m", "java"].enumerated().map { index, suffix in
            return "\(index)\(prefix)\(suffix)"
        }
        
        let swiftFiles = FileFilter.keepOnly(types: ["swift"], fileNames: fileNames)
        XCTAssertEqual(swiftFiles.count, 2)
        XCTAssertEqual(swiftFiles[0].suffix, "swift")
        XCTAssertEqual(swiftFiles[1].suffix, "swift")
        XCTAssertEqual(swiftFiles[0].fullPath.first, "0", "first swift file found should be the first file in the list")
        XCTAssertEqual(swiftFiles[1].fullPath.first, "2", "second swift file found shoul dbe the third file in the list") //
    }
    
}
