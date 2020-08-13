
import Foundation
public class Exec
{
    public static func exec(call: [String]) throws  {
        print("VX: Exec is going to do this: '\(call)'")
        let ls = Process()
        ls.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        ls.arguments = call
        try ls.run()
    }
}
