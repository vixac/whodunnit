
import Foundation
public class Exec
{
    
    //VX:TODO RM
    public static func exec(call: [String]) throws  {
        let ls = Process()
        ls.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        ls.arguments = call
        try ls.run()
    }
    
    public static func execute(call: [String]) throws -> [String] {
        let task = Process()
        
        task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        task.arguments = call

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: String.Encoding.utf8) {
            let lines = output.split(separator: "\n").map {"\($0)"}
            return lines
        }
        print("VX: no string data...")
        return []
    }
    public static func getEnvironmentVar(_ name: String) -> String? {
           guard let rawValue = getenv(name) else {
              return nil
           }
           return String(utf8String: rawValue)
       }
    
}
