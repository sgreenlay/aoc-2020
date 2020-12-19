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

func matches(_ input: String, index: Int, rule: Int, rules: [Int: Rule]) -> [Int] {
    if index >= input.count {
        return []
    }
    
    switch rules[rule]! {
        case .MatchCharacter(let ch):
            if input.characterAt(offset: index) == ch {
                return [index + 1]
            }
            return []
        case .MatchOneOf(let possibilities):
            return possibilities.flatMap({
                return $0.reduce([index], { (indicies, rule) in
                    indicies.flatMap({ matches(input, index: $0, rule: rule, rules: rules) })
                })
            })
    }
}

func part1(_ input: String) -> Int {
    let (rules, cases) = parseInput(input)
    let valid = cases.filter({ testCase in
        let indicies = matches(testCase, index: 0, rule: 0, rules: rules)
        return indicies.first(where: { $0 == testCase.count }) != nil
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

try! test(part1("""
42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
""") == 3, "part1")

func part2(_ input: String) -> Int {
    var (rules, cases) = parseInput(input)
    
    /*
     8: 42 | 42 8
     11: 42 31 | 42 11 31
     */
    rules[8] = .MatchOneOf([[42], [42, 8]])
    rules[11] = .MatchOneOf([[42, 31], [42, 11, 31]])
    
    let valid = cases.filter({ testCase in
        let indicies = matches(testCase, index: 0, rule: 0, rules: rules)
        return indicies.first(where: { $0 == testCase.count }) != nil
    })
    return valid.count
}

try! test(part2("""
42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
""") == 12, "part2")
 
let input = try! String(contentsOfFile: "input/day19.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
