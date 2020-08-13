
import Foundation
import WhodunnitLib
import ArgumentParser

struct BreakdownArg: ParsableCommand {

    @Argument(help: "file containing summary of each line")
    var lineSummaryFile: String
    
    mutating func run() throws {

        let contents = try String(contentsOfFile: lineSummaryFile)
        let lines: [String] = contents.split(separator: "\n").map {"\($0)"}
        let personMap = DirectPersonMap()
        let summaries: [LineSummary?] =  lines.map { line in
            print("VX: todo inspect this line: \(line)")
            guard let summary = try? LineSummary(authorMapper: personMap, line: line) else {
                return nil
            }
            return summary
        }
        let filteredErrors: [LineSummary] = summaries.compactMap {$0}
        let aggregation = LineAggregation(lines: filteredErrors)
        
        print("VX: there were \(summaries.count -  filteredErrors.count) ignored lines out of \(summaries.count) lines")
        print("VX: aggregation is \(aggregation)")
    }
}
