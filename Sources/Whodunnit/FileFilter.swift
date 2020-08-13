import Foundation

/**
   Determines the type of file based on the filename
 */

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


public class FileFilter {
}
