import Foundation
import Utils

func parseInput(_ input: String) -> [Int] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({ $0.asInt()! })
}

func part1(_ input: String) -> Int {
    let adapters = parseInput(input).sorted()
    
    var rating = 0
    
    var counts = [0, 0, 0, 0]
    for i in 0..<adapters.count {
        let delta = adapters[i] - rating
        guard delta >= 1 && delta <= 3 else {
            fatalError()
        }
        counts[delta] += 1
        rating = adapters[i]
    }
    return counts[1] * (counts[3] + 1)
}

assert(part1("""
16
10
15
5
1
11
7
19
6
12
4
""") == 7 * 5)

assert(part1("""
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
""") == 22 * 10)

func part2(_ input: String) -> Int {
    let adapters = parseInput(input).sorted()
    
    var paths = [0: 1]
    for n in adapters {
        var count = 0
        for i in 1...3 {
            if paths[n-i] != nil {
                count += paths[n-i]!
            }
        }
        paths[n] = count
    }
    return paths[adapters.last!]!
}

assert(part2("""
16
10
15
5
1
11
7
19
6
12
4
""") == 8)

assert(part2("""
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
""") == 19208)

let input = try! String(contentsOfFile: "input/day10.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
