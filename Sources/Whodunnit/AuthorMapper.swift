//
//  AuthorMapper.swift
//  WhodunnitLib
//
//  Created by shifu on 13/08/2020.
//

import Foundation

public protocol AuthorMapper {
    func authorIdToPerson(id: String) -> Person
}

public class DirectPersonMap: AuthorMapper {
    public init(){}
    public func authorIdToPerson(id: String) -> Person {
        return .init(name: id)
    }
}

public struct AuthorMapCodable: Codable {
    let person: String
    let aliases: [String]
}

public class PersonMapJsonReader {
    
    public static func toMap(jsonString: String) throws -> PersonMap {
        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let authors = try decoder.decode([AuthorMapCodable].self, from: data)
        authors.forEach {
            print("VX: author is \($0)")
        }
        return PersonMap(authorMap: authors)
    }
}

public class PersonMap: AuthorMapper {
    
    private var unmappedPeople: [String] = [] //collection of names we've not mapped.
    
    //map an actual person name to their many git author names
    private let mapFromAuthorNamesToPersonName: [String: String]
    convenience init(authorMap: [AuthorMapCodable]) {
        var map: [String: [String]] = [:]
        authorMap.forEach { author in
            map[author.person] = author.aliases
        }
        self.init(map: map)
    }
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
