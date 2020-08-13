
import Foundation
import WhodunnitLib
import ArgumentParser

struct BreakdownArg: ParsableCommand {

    @Argument(help: "file containing summary of each line")
    var lineSummaryFile: String
    
    mutating func run() throws {
        
        guard let whoPath = Exec.getEnvironmentVar("WHO_DIR") else {
            print("VX: who path not set. Error") //VX:TODO throw
            return
        }
        
        let contents = try String(contentsOfFile: lineSummaryFile)
        let sourceFilenames: [String] = contents.split(separator: "\n").map {"\($0)"}
        try sourceFilenames.forEach {
            print("VX: todo inspect this line: \($0)")
            //try Exec.exec(call: ["\(whoPath)/scripts/blame_file.sh", $0])
        }
    }
}
