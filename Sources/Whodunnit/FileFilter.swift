import Foundation

/**
   Determines the type of file based on the filename
 */


//VX:TODO consider removing filetype.
public enum FileType: String  {
    case swift = "swift"
    case objc  = "m"
    case header = "h"
    case storyboard = "storyboard"
    case xib = "xib"
    case unknown = "*"
    
    public static func from(filename: String) -> FileType {
        guard let last = filename.split(separator: ".").last else {
            return .unknown
        }
        guard let fileType = FileType(rawValue: "\(last)") else {
            return .unknown
        }
        return fileType
    }
}

public struct FileNameSummary {
    //VX:TODO we could extract the xcode project, or underlying directory, or something.
    public let fullPath: String
    let type: FileType //VX:TODO RM
    public let suffix: String
    public init(fullPath: String) {
        self.fullPath = fullPath
        self.type = FileType.from(filename: fullPath)
        let last = fullPath.split(separator: ".").last
        self.suffix = "\(last ?? "")"
    }
}

public class FileFilter {
    public static func keepOnly(types: [FileType], fileNames: [String]) -> [FileNameSummary] {
        let allSummaries: [FileNameSummary] = fileNames.map { FileNameSummary(fullPath: $0) }
        let setOfTypes = Set(types)
        let filtered = allSummaries.filter { setOfTypes.contains($0.type)}
        return filtered
    }
    
    public static func keepOnly(types: [String], fileNames: [String]) -> [FileNameSummary] {
        let allSummaries: [FileNameSummary] = fileNames.map { FileNameSummary(fullPath: $0) }
        let setOfTypes = Set(types)
        let filtered = allSummaries.filter { setOfTypes.contains($0.suffix)}
        return filtered
    }
}
