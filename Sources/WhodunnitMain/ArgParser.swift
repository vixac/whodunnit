import Foundation
import Whodunnit
import ArgumentParser



struct FileFilterArg: ParsableCommand {
  //  @Flag(help: "Include a counter with each repetition.")
  //  var includeCounter = false

    
    @Option(name: .shortAndLong, help:"quoted string of filetypes you wish to count")
    var suffixes: String?
    @Option(name: .shortAndLong, help: "File containing list of files.")
    var listOfFiles: String

   // @Argument(help: "File containing list of filenames")
    

    mutating func run() throws {
        
        let contents = try String(contentsOfFile: listOfFiles)
        let sourceFilenames: [String] = contents.split(separator: "\n").map {"\($0)"}
        
        let chosenFiles: [FileSummary]
        if let suffixes = suffixes {
            let suffixArray: [String] = suffixes.split(separator: " ").map {"\($0)"}
            chosenFiles = FileFilter.keepOnly(types: suffixArray, fileNames: sourceFilenames)
        } else {
            chosenFiles = sourceFilenames.map { FileSummary(fullPath: $0)}
        }
        //let allFilesCount = sourceFilenames.count
        //let chosenCount = chosenFiles.count
        chosenFiles.forEach {
            print("\($0.fullPath)")
        }
    }
}
