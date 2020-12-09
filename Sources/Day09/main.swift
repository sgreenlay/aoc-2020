import Foundation
import Utils

func parseInput(_ input: String) -> [Int] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({ $0.asInt()! })
}

func part1(_ input: String, preamble: Int) -> Int {
    let numbers = parseInput(input)

    for i in preamble..<numbers.count {
        var seen = Dictionary<Int, Int>()
        for j in i-preamble..<i {
            let val = numbers[j]
            if seen[val] != nil {
                seen[val]! += 1
            } else {
                seen[val] = 1
            }
        }
        
        var isValid = false
        for val in seen {
            let remaining = numbers[i] - val.key
            if seen[remaining] != nil {
                if remaining == val.key && val.value == 1 {
                    continue
                }
                
                isValid = true
                break
            }
        }
        
        if !isValid {
            return numbers[i]
        }
    }
    
    fatalError()
}

let test = """
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
"""

let t1 = part1(test, preamble: 5)
assert(t1 == 127)

func part2(_ input: String, find: Int) -> Int {
    let numbers = parseInput(input)
 
    var min = 0
    var rollingSum = numbers[0]
    for max in 1..<numbers.count {
        rollingSum += numbers[max]
        while rollingSum > find {
            rollingSum -= numbers[min]
            min += 1
        }
        if rollingSum == find {
            let subsequence = Array(numbers[min...max])
            return subsequence.min()! + subsequence.max()!
        }
    }
    
    fatalError()
}

let t2 = part2(test, find: t1)
assert(t2 == 62)

let input = try! String(contentsOfFile: "input/day09.txt", encoding: String.Encoding.utf8)

let p1 = part1(input, preamble: 25)
let p2 = part2(input, find: p1)

print("\(p1)")
print("\(p2)")
