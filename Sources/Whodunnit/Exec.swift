
import Foundation
public class Exec
{
    public static func exec(call: [String]) throws  {
        let ls = Process()
        ls.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        ls.arguments = call
        try ls.run()
    }
    
    public static func getEnvironmentVar(_ name: String) -> String? {
           guard let rawValue = getenv(name) else {
              return nil
           }
           return String(utf8String: rawValue)
       }
    
}
