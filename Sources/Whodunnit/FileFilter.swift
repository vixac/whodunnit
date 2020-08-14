import Foundation

/**
   Determines the type of file based on the filename
 */

public struct FileNameSummary {
    public let fullPath: String
    public let suffix: String
    public init(fullPath: String) {
        self.fullPath = fullPath
        let last = fullPath.split(separator: ".").last
        self.suffix = "\(last ?? "")"
    }
}

public class FileFilter {

    public static func keepOnly(types: [String], fileNames: [String]) -> [FileNameSummary] {
        let allSummaries: [FileNameSummary] = fileNames.map { FileNameSummary(fullPath: $0) }
        let setOfTypes = Set(types)
        let filtered = allSummaries.filter { setOfTypes.contains($0.suffix)}
        return filtered
    }
}
