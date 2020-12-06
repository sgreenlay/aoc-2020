import Foundation
import Utils

func part1(_ input: String) -> Int {
    let groups = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n\n")
    
    var sum = 0
    for group in groups {
        var answers = Set<Character>()
        for answer in group {
            if answer.isWhitespace {
                continue
            }
            answers.insert(answer)
        }
        sum += answers.count
    }

    return sum
}

assert(part1("""
abc

a
b
c

ab
ac

a
a
a
a

b
""") == 11)

func part2(_ input: String) -> Int {
    let groups = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n\n")
    
    var sum = 0
    for group in groups {
        var answers = Dictionary<Character, Int>()
        
        var participants = 1
        for answer in group {
            if answer.isWhitespace {
                participants += 1
                continue
            }
            if !answers.keys.contains(answer) {
                answers[answer] = 1
            } else {
                answers[answer]! += 1
            }
        }

        sum += answers.filter({ $0.value ==  participants}).count
    }

    return sum
}

assert(part2("""
abc

a
b
c

ab
ac

a
a
a
a

b
""") == 6)

let input = try! String(contentsOfFile: "input/day06.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
