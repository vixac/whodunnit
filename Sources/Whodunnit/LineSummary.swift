import Foundation

public enum LineSummaryError: Error {
    case invalidDate(String)
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

public protocol AuthorMapper {
    func authorIdToPerson(id: String) -> Person
}

public class DirectPersonMap: AuthorMapper {
    public init(){}
    public func authorIdToPerson(id: String) -> Person {
        return .init(name: id)
    }
}

public class PersonMap: AuthorMapper {
    
    private var unmappedPeople: [String] = [] //collection of names we've not mapped.
    
    //map an actual person name to their many git author names
    private let mapFromAuthorNamesToPersonName: [String: String]
    init(map: [String: [String]]) { //this is person Name -> [git name]
        
        var reverseMap: [String: String] = [:]
        map.keys.forEach { personName in
            let gitAliases = map[personName]!
            gitAliases.forEach { gitName in
                reverseMap[gitName] = personName
            }
            
        }
        self.mapFromAuthorNamesToPersonName = reverseMap
    }
    public func authorIdToPerson(id: String) -> Person {
        guard let name = mapFromAuthorNamesToPersonName[id] else {
            self.unmappedPeople.append(id)
            return Person(name: nil)
        }
        return Person(name: name)
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
        //print("VX: words are: \(words)")
        guard words.count > 4 else {
            throw LineSummaryError.notEnoughWords(line: line)
        }
        self.commit = words[0]
        self.fileSummary = FileNameSummary(fullPath: words[1])
        let authorAlias = words[3].replacingOccurrences(of: "(", with: "")
        self.person = authorMapper.authorIdToPerson(id: authorAlias)
        self.lineNumber  = Int(words[2]) ?? 0  //VX:TODO throw
        let dateString = words[4]
        
        guard let date = LineSummary.formatter.date(from: dateString) else {
            throw LineSummaryError.invalidDate(dateString)
        }
        self.commitDate = date
    }
}

public struct AuthorContribution {
    let numLines: Int
    let person: Person
}

public struct Contributors {
    let authors: [AuthorContribution]
    init(authors: [AuthorContribution]) {
        self.authors = authors.sorted(by: {a , b in
            a.numLines > b.numLines
        })
    }
}

public struct LineAggregation {
    public let contributors: Contributors
    public init(lines: [LineSummary]) {
        var contribution: [Person: Int] = [:]
        lines.forEach {
            let person = $0.person
            if contribution[person] == nil {
                contribution[person] = 1
            } else {
                contribution[person] = contribution[person]! + 1
            }
        }
        
        let authorContributions: [AuthorContribution] = contribution.keys.map { person in
            let lineCount = contribution[person]!
            return AuthorContribution(numLines: lineCount, person: person)
        }
        contributors = Contributors(authors: authorContributions)
    }
}
