import Foundation

public enum LineSummaryError: Error {
    case invalidDate(String)
    case invalidLineNumber(String)
    case notEnoughWords(line: String)
    case noLineCount(String)
}

//VX:TODO move this and test person map.
public struct Person: Hashable {
    
    public let name: String?
    //nil for unknown person
    public init(name: String?) {
        self.name = name
    }
    
    public func isUnknownPerson() -> Bool {
        return self.name == nil
    }
}

struct Next {
    private var val: Int
    init(start: Int) {
        val = start
    }
    
    func value() -> Int {
        return self.val
    }
    mutating func next() -> Int {
        let result = val
        self.val += 1
        return result
    }
    
}
public struct LineSummary {
    static var formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    public let commit: String
    public let fileSummary: FileNameSummary
    public let person: Person
    public let lineNumber: Int
    public let commitDate: Date
    
    public init(commit: String, fileSummary: FileNameSummary, person: Person, lineNumber: Int, commitDate: Date) {
        self.commit = commit
        self.fileSummary = fileSummary
        self.person = person
        self.lineNumber = lineNumber
        self.commitDate = commitDate
    }
    
    
    private static func indexofLineCount(lines: [String]) -> Int? {
        
        for i in 0..<lines.count {
            if let _ = Int(lines[i]) {
                return i
            }
        }
        return nil
    }
    
    public init( authorMapper: AuthorMapper, line: String) throws {
       let words: [String] = line.split(separator: " ").filter { $0 != " "}.map { "\($0)"}
       guard words.count > 5 else {
           throw LineSummaryError.notEnoughWords(line: line)
       }
       var next = Next(start: 0)
       self.commit = words[next.next()]
    
    
        guard let lineCountIndex = LineSummary.indexofLineCount(lines: words) else {
            throw LineSummaryError.noLineCount(line)
        }
    
       self.fileSummary = FileNameSummary(fullPath: words[lineCountIndex - 1])
    
        guard let lineNum = Int(words[lineCountIndex]) else {
           throw LineSummaryError.invalidLineNumber(words[next.value()])
        }
        self.lineNumber = lineNum
        
        
        var dateIndex: Int? = nil
        for i in lineCountIndex..<words.count {
            if words[i].contains("20") {
                dateIndex = i
                break
            }
        }
        guard let theDateIndex = dateIndex else {
            throw LineSummaryError.invalidDate(line)
        }
        
        let firstNameindex = lineCountIndex + 1
        
        //let lastNameIndex = theDateIndex - 1
        var name: String = ""
        for i in firstNameindex..<theDateIndex {
            name += words[i]
            if i != theDateIndex - 1 {
                name += " "
            }
        }
        
        
        let fullName = name.replacingOccurrences(of: "(", with: "")
        print("VX: full name is \(fullName)")
        self.person = authorMapper.authorIdToPerson(id: fullName)
        let dateString = words[theDateIndex]
        
        /*
       let lastNameOrDate = words[next.next()]
       let dateString: String
       if lastNameOrDate.contains("20") {
           self.person = authorMapper.authorIdToPerson(id: firstName)
           dateString = lastNameOrDate
       } else {
           self.person = authorMapper.authorIdToPerson(id: "\(firstName) \(lastNameOrDate)")
           dateString = words[next.next()]
       }
*/
       guard let date = LineSummary.formatter.date(from: dateString) else {
           throw LineSummaryError.invalidDate(dateString)
       }
       self.commitDate = date
   }

    
    /*
    public init( authorMapper: AuthorMapper, line: String) throws {
        let words: [String] = line.split(separator: " ").filter { $0 != " "}.map { "\($0)"}
        guard words.count > 5 else {
            throw LineSummaryError.notEnoughWords(line: line)
        }
        var next = Next(start: 0)
        self.commit = words[next.next()]
        self.fileSummary = FileNameSummary(fullPath: words[next.next()])
        guard let lineNum = Int(words[next.next()]) else {
            throw LineSummaryError.invalidLineNumber(words[next.value()])
        }
        self.lineNumber = lineNum
        
        let firstName = words[next.next()].replacingOccurrences(of: "(", with: "")
        let lastNameOrDate = words[next.next()]
        let dateString: String
        if lastNameOrDate.contains("20") {
            self.person = authorMapper.authorIdToPerson(id: firstName)
            dateString = lastNameOrDate
        } else {
            self.person = authorMapper.authorIdToPerson(id: "\(firstName) \(lastNameOrDate)")
            dateString = words[next.next()]
        }

        guard let date = LineSummary.formatter.date(from: dateString) else {
            throw LineSummaryError.invalidDate(dateString)
        }
        self.commitDate = date
    }*/
}
