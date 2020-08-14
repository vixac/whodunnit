
import Foundation
import XCTest
@testable import WhodunnitLib

class LineSummaryTests: XCTestCase {

    func simpleAuthorMap() -> PersonMap {
        return PersonMap(map: ["vic": ["bob smith", "v"]])
    }
    
    func testOneLine() {
        do {
            let authorMapper = simpleAuthorMap()
            let filter = try LineSummary(authorMapper: authorMapper, line: " 937e73692df8422507cfe84eaf7f163da387ac35 Source/VxdayView.swift       772 (bob smith    2017-08-22 20:31:07 +0100 820)                           done 0c441b2b0")
            
            XCTAssertEqual(filter.commit, "937e73692df8422507cfe84eaf7f163da387ac35")
            XCTAssertEqual(filter.fileSummary.suffix, "swift")
            XCTAssertEqual(filter.lineNumber,772)
            XCTAssertEqual(filter.person.name,"vic")
            XCTAssertEqual(filter.commitDate.description,"2017-08-21 23:00:00 +0000")
            
        } catch {
            XCTFail("error is \(error)")
        }
    }
    func testOneLineSingleName() {
        do {
            let authorMapper = simpleAuthorMap()
            let filter = try LineSummary(authorMapper: authorMapper, line: " 937e73692df8422507cfe84eaf7f163da387ac35 Source/VxdayView.swift       772 (v    2017-08-22 20:31:07 +0100 820)                           done 0c441b2b0")
            
            XCTAssertEqual(filter.commit, "937e73692df8422507cfe84eaf7f163da387ac35")
            XCTAssertEqual(filter.fileSummary.suffix, "swift")
            XCTAssertEqual(filter.lineNumber,772)
            XCTAssertEqual(filter.person.name,"vic")
            XCTAssertEqual(filter.commitDate.description,"2017-08-21 23:00:00 +0000")
            
        } catch {
            XCTFail("error is \(error)")
        }
    }
    
    
    func testAggregation() {
        
        let people: [String] = ["alice", "bob", "carol", "daniel"]
        
        //these numbers are the index into people names above
        let summaries: [LineSummary] = [0,1,3,0,1,0].enumerated().map { index, value in
            return LineSummary(commit: "<hash>", fileSummary: .init(fullPath: "file\(index)/path\(value).swift"), person: .init(name: people[value]), lineNumber: index, commitDate: Date())
        }
        
        let aggregation = LineAggregation(lines: summaries)
        XCTAssertEqual(aggregation.contributors.authors.count, 3)
        XCTAssertEqual(aggregation.contributors.authors[0].numLines, 3)
        XCTAssertEqual(aggregation.contributors.authors[0].person.name, "alice")
        
        XCTAssertEqual(aggregation.contributors.authors[1].numLines, 2)
        XCTAssertEqual(aggregation.contributors.authors[1].person.name, "bob")
        
        XCTAssertEqual(aggregation.contributors.authors[2].numLines, 1)
        XCTAssertEqual(aggregation.contributors.authors[2].person.name, "daniel")
    }
    
    func testPersonMap() {
        let alias1 = AuthorMapCodable(person: "vic", aliases: ["vic zac", "victor"])
        let alias2 = AuthorMapCodable(person: "zac", aliases: ["zac", "z"])
        let array = [alias1, alias2]
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(array)
            guard let string = String(data: data, encoding: .utf8) else {
                XCTFail("string from data failed")
                return
            }
            let map = try PersonMapJsonReader.toMap(jsonString: string)
            XCTAssertEqual(map.authorIdToPerson(id: "z").name, "zac")
            XCTAssertEqual(map.authorIdToPerson(id: "vic zac").name, "vic")
        } catch {
            XCTFail("error is \(error)")
        }
        
    }
}
