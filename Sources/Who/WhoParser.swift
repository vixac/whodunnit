import Foundation
import WhodunnitLib
import ArgumentParser

public enum ReportType: String, CaseIterable {
    case authors
    //case file
    //case directory
    //case busfactor
    case fetchFiles
    case lineByLine
    
    static func allOfThem() -> String {
        let cases = ReportType.allCases.map {$0.rawValue}
        return cases.joined(separator: " ")
    }
}

extension Exec {

    static public func allGitFilesInBranch(branch: String) throws -> [String]  {
        return try Exec.execute(call: ["git", "ls-tree", "-r", branch, "--name-only"])
    }
    
    //git blame -lfnwM $1
    static public func createlineSummary(filename: String) throws {
        guard let whoPath = Exec.getEnvironmentVar("WHO_DIR") else {
            print("VX: who path not set. Error") //VX:TODO throw
            return
        }
        
        
        try Exec.execAndPrint(call: ["\(whoPath)/scripts/blame_file.sh", filename] )
        //return try Exec.execute(call: ["wc","-l", filename] )
    }
}


class WhoLogic {
    
    static func runFetchFiles(branch: String, suffixes: String?) throws {
        let files = try fetchFiles(branch: branch, suffixes: suffixes)
        files.forEach {
           print("\($0.fullPath)")
        }
    }
    
    static func annotateFiles(branch: String, suffixes: String?) throws {
        let files = try fetchFiles(branch: branch, suffixes: suffixes)
        try files.forEach {
            try Exec.createlineSummary(filename: $0.fullPath)
            //print("VX: TODO create line summary for \($0)")
        }
    }
    static func fetchFiles(branch: String, suffixes: String?) throws -> [FileNameSummary]  {
        let allFileNames = try Exec.allGitFilesInBranch(branch: branch)
        let chosenFiles: [FileNameSummary]
         if let suffixes = suffixes {
            let suffixArray: [String] = suffixes.split(separator: " ").map {"\($0)"}
                chosenFiles = FileFilter.keepOnly(types: suffixArray, fileNames: allFileNames)
        } else {
            chosenFiles = allFileNames.map { FileNameSummary(fullPath: $0)}
        }
        return chosenFiles

    }
    
    static func contributors(blameFile: String, personMap: AuthorMapper) throws  {
        let contents = try String(contentsOfFile: blameFile)
        let lines: [String] = contents.split(separator: "\n").map {"\($0)"}
        //let personMap = DirectPersonMap()
        let summaries: [LineSummary?] =  lines.map { line in
            guard let summary = try? LineSummary(authorMapper: personMap, line: line) else {
                print("VX: TODO IGNORING THIS LINE: \(line)")
                return nil
            }
            return summary
        }
        let filteredErrors: [LineSummary] = summaries.compactMap {$0}
        let aggregation = LineAggregation(lines: filteredErrors)
        
        print("VX:xx there were \(summaries.count -  filteredErrors.count) ignored lines out of \(summaries.count) lines")
        //print("VX: aggregation is \(aggregation)")
        aggregation.contributors.authors.forEach { author in
            print("VX: author \(author.person.name ?? "Unknown Person"): lineCount: \(author.numLines)")
        }
    }
}


public enum WhoArgError: Error {
    case missingBlameFile
}

struct WhoArg: ParsableCommand {

    @Option(name: .shortAndLong, help: "json file that contains mappings from authors to their many git aliases")
    var authorFile: String?
    
    @Option(name: .shortAndLong, help: "branch name")
    var branchName: String?
    
    @Option(name: .shortAndLong, help: "report type. Your options are: \(ReportType.allOfThem())")
    var reportType: String?
    
    @Option(name: .shortAndLong, help:"quoted string of filetypes you wish to count")
    var suffixes: String?
    
    @Option(name: .long, help:"Blame file, the output of ./scripts/blame_file.sh")
    var blameFile: String?
    
    
    private func toAuthorMap() throws  -> AuthorMapper {
        guard let file = authorFile else {
            return DirectPersonMap()
        }
        let contents = try String(contentsOfFile: file)
        return  try PersonMapJsonReader.toMap(jsonString: contents)
    }
    
    mutating func run() throws {
        let theBranchName = branchName ?? "develop"
        let authorMap = try toAuthorMap()
        let theReportType: ReportType = ReportType(rawValue: reportType ?? "") ?? .authors
        switch theReportType {
        case .fetchFiles:
            try WhoLogic.runFetchFiles(branch: theBranchName, suffixes: suffixes)
        case .authors:
            guard let blameFile = blameFile else {
                print("Error, you must provide a blame file.")
                throw WhoArgError.missingBlameFile
            }
            try WhoLogic.contributors(blameFile: blameFile, personMap: authorMap)
        //case .lineByLine:
        case .lineByLine:
            //print("VX: TODO line by line")
            try WhoLogic.annotateFiles(branch: theBranchName, suffixes: suffixes)
        default:
            print("VX report: \(theReportType) not supported yet.")
            
        }
        
      
        //gitblame. Doesnt work with stdout
        /*
        print("first file is \(first)")
        let annotation = try Exec.createlineSummary(filename: first)

        print("VX: heres the annotation: \(annotation)")
        annotation.forEach {
            print("VX: annotation: \($0)")
        }*/
    }
}
