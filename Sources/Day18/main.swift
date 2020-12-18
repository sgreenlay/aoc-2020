import Foundation
import Utils

func parseInput(_ input: String) -> [String] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
}

func reduce(_ input: String, orderOfOperations: [CharacterSet]) -> String {
    var tokens = input.components(separatedBy: " ")
    
    for operations in orderOfOperations {
        var i = 0
        
        while i < tokens.count - 1 {
            let a = tokens[i].asInt()!
            i += 1
            
            let op = tokens[i].unicodeScalars.first!
            i += 1
            
            let b = tokens[i].asInt()!
            
            if operations.contains(op) {
                var c: Int
                switch op {
                    case "+":
                        c = a + b
                    case "*":
                        c = a * b
                    default:
                        fatalError()
                }
                tokens.remove(at: i)
                i -= 1

                tokens.remove(at: i)
                i -= 1
                
                tokens[i] = "\(c)"
            }
        }
    }
    if tokens.count != 1 {
        fatalError()
    }
    return tokens.first!
}

func eval(_ input: String, orderOfOperations: [CharacterSet]) -> Int {
    var stack = [String]()
    var current = ""
    
    for ch in input {
        switch ch {
        case "(":
            stack.append(current)
            current = ""
        case ")":
            var last = stack.popLast()!
            last.append(reduce(current, orderOfOperations: orderOfOperations))
            current = last
        default:
            current.append(ch)
        }
    }
    guard stack.count == 0 && current.count > 0 else {
        fatalError()
    }
    return reduce(current, orderOfOperations: orderOfOperations).asInt()!
}

func part1(_ input: String) -> Int {
    return parseInput(input).reduce(0, { $0 + eval($1, orderOfOperations: [CharacterSet(["+", "*"])]) })
}

try! test(part1("1 + 2 * 3 + 4 * 5 + 6") == 71, "part1")
try! test(part1("1 + (2 * 3) + (4 * (5 + 6))") == 51, "part1")
try! test(part1("2 * 3 + (4 * 5)") == 26, "part1")
try! test(part1("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 437, "part1")
try! test(part1("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 12240, "part1")
try! test(part1("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632, "part1")

func part2(_ input: String) -> Int {
    return parseInput(input).reduce(0, {
        $0 + eval($1, orderOfOperations: [CharacterSet(["+"]), CharacterSet(["*"])])
    })
}

try! test(part2("1 + 2 * 3 + 4 * 5 + 6") == 231, "part2")
try! test(part2("1 + (2 * 3) + (4 * (5 + 6))") == 51, "part2")
try! test(part2("2 * 3 + (4 * 5)") == 46, "part2")
try! test(part2("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 1445, "part2")
try! test(part2("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 669060, "part2")
try! test(part2("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 23340, "part2")
 
let input = try! String(contentsOfFile: "input/day18.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
