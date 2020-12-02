import Foundation
import Utils

struct Part1Condition {
    public var min: Int
    public var max: Int
    public var letter: Character
    
    public func validate(_ input: String) -> Bool {
        let letters = input.filter({ $0 == letter })
        return letters.count >= min && letters.count <= max
    }
}

func part1(_ input: String) -> Int {
    let inputs : [(Part1Condition, String)] = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({
            let scanner = Scanner(string: $0)

            // ##-## A: XXXXXX
            let min = scanner.scanInt()!
            let _ = scanner.scanString("-")!
            let max = scanner.scanInt()!
            let letter = scanner.scanUpToString(": ")!
            let _ = scanner.scanString(": ")!
            let password = String($0.suffix(from: scanner.currentIndex))
            
            return (Part1Condition(min: min, max: max, letter: letter.characterAt(offset: 0)!), password)
        })
    
    let valid = inputs.filter({ $0.0.validate($0.1) })
    return valid.count
}

assert(part1("""
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
""") == 2)

struct Part2Condition {
    public var pos1: Int
    public var pos2: Int
    public var letter: Character
    
    public func validate(_ input: String) -> Bool {
        let isAtPos1 = pos1 < input.count && input.characterAt(offset: pos1) == letter
        let isAtPos2 = pos2 < input.count && input.characterAt(offset: pos2) == letter
        
        if isAtPos1 {
            return !isAtPos2
        }
        return isAtPos2
    }
}


func part2(_ input: String) -> Int {
    let inputs : [(Part2Condition, String)] = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({
            let scanner = Scanner(string: $0)

            // ##-## A: XXXXXX
            let pos1 = scanner.scanInt()!
            let _ = scanner.scanString("-")!
            let pos2 = scanner.scanInt()!
            let letter = scanner.scanUpToString(": ")!
            let _ = scanner.scanString(": ")!
            let password = String($0.suffix(from: scanner.currentIndex))
            
            // Toboggan Corporate Policies have no concept of "index zero"
            return (Part2Condition(pos1: pos1-1, pos2: pos2-1, letter: letter.characterAt(offset: 0)!), password)
        })
    
    let valid = inputs.filter({ $0.0.validate($0.1) })
    return valid.count
}

assert(part2("""
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
""") == 1)

let input = try! String(contentsOfFile: "input/day02.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
