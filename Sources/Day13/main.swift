import Foundation
import Utils

func parseInput(_ input: String) -> (Int, [Int?]) {
    let lines = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
    
    let earliest = lines[0].asInt()!
    let times = lines[1].components(separatedBy: ",").map({ $0.asInt() })
    
    return (earliest, times)
}

func part1(_ input: String) -> Int {
    let (earliest, times) = parseInput(input)
    
    var currentTime = earliest
    var busId = 0
    findTime: while true {
        for time in times {
            guard time != nil else {
                continue
            }
            if currentTime % time! == 0 {
                busId = time!
                break findTime
            }
        }
        currentTime += 1
    }
    
    return (currentTime - earliest) * busId
}

assert(part1("""
939
7,13,x,x,59,x,31,19
""") == 295)

func part2(_ input: String) -> Int {
    let (_, times) = parseInput(input)
    
    let buses = times.filter({ $0 != nil }).map({ $0! })
    let idxs = buses.map({ times.firstIndex(of: $0)! })
    
    let result = chinese_remainder(n: buses, a: idxs.map({ times[$0]! - $0 }))
    return result
}

assert(part2("""
939
7,13,x,x,59,x,31,19
""") == 1068781)

assert(part2("""
0
17,x,13,19
""") == 3417)

assert(part2("""
0
67,7,59,61
""") == 754018)

assert(part2("""
0
67,x,7,59,61
""") == 779210)

assert(part2("""
0
67,7,x,59,61
""") == 1261476)

assert(part2("""
0
1789,37,47,1889
""") == 1202161486)

let input = try! String(contentsOfFile: "input/day13.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
