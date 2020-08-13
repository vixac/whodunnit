import Foundation
import ArgumentParser

struct ArgParser: ParsableCommand {
  //  @Flag(help: "Include a counter with each repetition.")
  //  var includeCounter = false

    @Option(name: .shortAndLong, help: "File containing list of files.")
    var listOfFiles: String?

   // @Argument(help: "File containing list of filenames")
    

    mutating func run() throws {
        guard let filename = listOfFiles else {
            print("VX: no file name")
            return
        }
        
        print("VX: TODO spit out files from \(listOfFiles)")
        let contents = try String(contentsOfFile: filename)
        let sourceFilenames = contents.split(separator: "\n")
        sourceFilenames.forEach {
            print("VX: FILE HAS LINE: \($0)")
        }
    }
}
