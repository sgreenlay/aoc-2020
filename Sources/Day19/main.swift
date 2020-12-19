import Foundation
import Utils

enum Rule {
    case MatchOneOf([[Int]])
    case MatchCharacter(Character)
    
    public static func parse(_ input: String) -> (Int, Rule) {
        let scanner = Scanner(string: input)
        
        let id = scanner.scanInt()!
        let _ = scanner.scanString(": ")!
        
        if scanner.scanString("\"") != nil {
            let ch = scanner.scanCharacter()!
            return (id, .MatchCharacter(ch))
        } else {
            let rules = input
                .suffix(from: scanner.currentIndex)
                .components(separatedBy: "|")
                .map({
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                      .components(separatedBy: " ")
                      .map({ $0.asInt()! })
                })
            return (id, .MatchOneOf(rules))
        }
    }
}

func parseInput(_ input: String) -> ([Int: Rule], [String]) {
    let lines = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
    
    var i = 0
    var rules = [Int: Rule]()
    while i < lines.count && lines[i] != "" {
        let (id, rule) = Rule.parse(lines[i])
        rules[id] = rule
        i += 1
    }
    i += 1
    
    let cases = Array(lines.suffix(from: i))
    return (rules, cases)
}

func isMatch(_ input: inout String, rule: Int, rules: [Int: Rule]) -> Bool {
    if input.count == 0 {
        return false
    }
    
    switch rules[rule]! {
        case .MatchCharacter(let ch):
            if input.characterAt(offset: 0) == ch {
                input.remove(at: input.indexAt(offset: 0))
                return true
            }
            return false
        case .MatchOneOf(let possibilities):
            for match in possibilities {
                var nextInput = input
                if match.first(where: { !isMatch(&nextInput, rule: $0, rules: rules) }) == nil {
                    input = nextInput
                    return true
                }
            }
            return false
    }
}

func part1(_ input: String) -> Int {
    let (rules, cases) = parseInput(input)
    let valid = cases.filter({ input in
        var temp = input
        return isMatch(&temp, rule: 0, rules: rules) && temp.count == 0
    })
    return valid.count
}

try! test(part1("""
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
""") == 2, "part1")
 
let input = try! String(contentsOfFile: "input/day19.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
//print("\(part2(input))")
