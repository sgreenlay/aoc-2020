import Foundation
import Utils

func part1(_ input: String) -> Int {
    let numbers = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({ $0.asInt()! })
    
    for i in 0..<numbers.count-1 {
        for j in i+1..<numbers.count {
            if numbers[i] + numbers[j] == 2020 {
                return numbers[i] * numbers[j]
            }
        }
    }
    fatalError()
}

assert(part1("""
1721
979
366
299
675
1456
""") == 514579)

func part2(_ input: String) -> UInt64 {
    let numbers = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({ UInt64($0.asInt()!) })
    
    for i in 0..<numbers.count-2 {
        for j in i+1..<numbers.count-1 {
            for k in j+1..<numbers.count {
                if numbers[i] + numbers[j] + numbers[k] == 2020 {
                    return numbers[i] * numbers[j] * numbers[k]
                }
            }
        }
    }
    fatalError()
}

assert(part2("""
1721
979
366
299
675
1456
""") == 241861950)

let input = try! String(contentsOfFile: "input/day01.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
