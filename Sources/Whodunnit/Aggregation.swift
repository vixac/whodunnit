import Foundation

public struct AuthorContribution {
    public let numLines: Int
    public let person: Person
}

public struct Contributors {
    public let authors: [AuthorContribution]
    public init(authors: [AuthorContribution]) {
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
