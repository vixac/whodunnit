import Foundation

public enum LineSummaryError: Error {
    case invalidDate(String)
    case invalidLineNumber(String)
    case notEnoughWords(line: String)
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
    }
}
