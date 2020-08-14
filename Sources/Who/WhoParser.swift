import Foundation
import WhodunnitLib
import ArgumentParser

public enum ReportType: String {
    case author
    case file
    case directory
    case busfactor
}

extension Exec {
    //git ls-tree -r master --name-only
    static func createAllFiles(branch: String) throws  {
        try Exec.exec(call: ["git", "ls-tree", "-r", branch, "--name-only"])
    }
}

struct WhoArg: ParsableCommand {

    @Option(name: .shortAndLong, help: "json file that contains mappings from authors to their many git aliases")
    var authorFile: String?
    
    @Option(name: .shortAndLong, help: "branch name")
    var branchName: String?
    
    @Option(name: .shortAndLong, help: "report type. Your options are: author, file, directory, busfactor")
    var reportType: String?
    
    mutating func run() throws {
        let authorMap: AuthorMapper
        if let authorFile = authorFile {
            let contents = try String(contentsOfFile: authorFile)
            authorMap = try PersonMapJsonReader.toMap(jsonString: contents)
            print("VX: auuthor map is \(authorMap.authorIdToPerson(id: "Spidey"))")
        } else {
            authorMap = DirectPersonMap()
        }
        
        let theBranchName = branchName ?? "develop"
        
        let theReportType: ReportType = ReportType(rawValue: reportType ?? "") ?? .author
        
        print("VX branch name is \(theBranchName). Report type: \(theReportType.rawValue)")
        
        try Exec.createAllFiles(branch: theBranchName)
    }
}
