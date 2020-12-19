import Foundation
import Utils

enum Rule {
    case MatchRules(Int, [[Int]])
    case MatchCharacter(Int, Character)
    
    public func isMatch(_ input: String, index: inout Int, rules: [Rule]) -> Bool {
        switch self {
            case .MatchRules(_, let toMatch):
                for match in toMatch {
                    var i = index
                    let matches = match.reduce(true, {
                        $0 && rules[$1].isMatch(input, index: &i, rules: rules)
                    })
                    if matches {
                        index = i
                        return true
                    }
                }
                return false
            case .MatchCharacter(_, let ch):
                if input.characterAt(offset: index) == ch {
                    index += 1
                    return true
                }
                return false
        }
    }
    
    public static func parse(_ input: String) -> Rule {
        let scanner = Scanner(string: input)
        
        let id = scanner.scanInt()!
        let _ = scanner.scanString(": ")!
        
        if scanner.scanString("\"") != nil {
            let ch = scanner.scanCharacter()!
            return .MatchCharacter(id, ch)
        } else {
            let rules = input
                .suffix(from: scanner.currentIndex)
                .components(separatedBy: "|")
                .map({
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                      .components(separatedBy: " ")
                      .map({ $0.asInt()! })
                })
            return .MatchRules(id, rules)
        }
    }
}

func parseInput(_ input: String) -> ([Rule], [String]) {
    let lines = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
    
    var i = 0
    var rules = [Rule]()
    while i < lines.count && lines[i] != "" {
        rules.append(Rule.parse(lines[i]))
        i += 1
    }
    i += 1
    
    let cases = Array(lines.suffix(from: i))
    return (rules, cases)
}

func part1(_ input: String) -> Int {
    let (rules, cases) = parseInput(input)
    let valid = cases.filter({
        var index = 0
        return rules[0].isMatch($0, index: &index, rules: rules) && (index == $0.count)
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
