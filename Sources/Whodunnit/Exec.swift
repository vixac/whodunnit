
import Foundation
public class Exec
{
    public static func exec(call: [String]) throws  {
        let ls = Process()
        ls.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        ls.arguments = call
        try ls.run()
    }
}
