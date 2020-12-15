import Foundation
import Utils

func parseInput(_ input: String) -> [Int] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: ",")
        .map({ $0.asInt()! })
}

func nthNumberSpoken(_ input: String, n: Int) -> Int {
    let numbers = parseInput(input)
    
    var numbersSpoken = Dictionary<Int, Int>()

    var lastNumber = numbers[0]
    numbersSpoken[lastNumber] = 1

    for turn in 2...n {
        var number = 0
        
        if turn <= numbers.count {
            number = numbers[turn - 1]
        } else if numbersSpoken[lastNumber] != nil {
            number = turn - numbersSpoken[lastNumber]!
        }
        
        numbersSpoken[lastNumber] = turn
        lastNumber = number
    }
    
    return lastNumber
}

func part1(_ input: String) -> Int {
    return nthNumberSpoken(input, n: 2020)
}

assert(part1("0,3,6") == 436)
assert(part1("1,3,2") == 1)
assert(part1("2,1,3") == 10)
assert(part1("1,2,3") == 27)
assert(part1("2,3,1") == 78)
assert(part1("3,2,1") == 438)
assert(part1("3,1,2") == 1836)

func part2(_ input: String) -> Int {
    return nthNumberSpoken(input, n: 30_000_000)
}

assert(part2("0,3,6") == 175594)
assert(part2("1,3,2") == 2578)
assert(part2("2,1,3") == 3544142)
assert(part2("1,2,3") == 261214)
assert(part2("2,3,1") == 6895259)
assert(part2("3,2,1") == 18)
assert(part2("3,1,2") == 362)

let input = try! String(contentsOfFile: "input/day15.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
