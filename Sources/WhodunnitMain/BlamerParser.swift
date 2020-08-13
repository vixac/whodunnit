import Foundation
import WhodunnitLib
import ArgumentParser

struct BlamerArg: ParsableCommand {
  //  @Flag(help: "Include a counter with each repetition.")
  //  var includeCounter = false

    @Argument(help: "file containing list of files on which to run blame")
    var listOfFiles: String
    
    mutating func run() throws {
        
        let contents = try String(contentsOfFile: listOfFiles)
        let sourceFilenames: [String] = contents.split(separator: "\n").map {"\($0)"}
        try sourceFilenames.forEach {
            try Exec.exec(call: ["./scripts/blame_file.sh", $0])
        }
    }
}
