import Foundation
import Utils

enum Token {
    case Number(Int)
    case Add
    case Multiply
    case OpenParen
    case CloseParen
}

func parseInput(_ input: String) -> [[Token]] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({
            return Array($0
                .components(separatedBy: " ")
                .map({ (input: String) -> [Token] in
                    switch input {
                        case "*":
                            return [.Multiply]
                        case "+":
                            return [.Add]
                        default:
                            var tokens = [Token]()
                            let scanner = Scanner(string: input)
                            
                            while let _ = scanner.scanString("(") {
                                tokens.append(.OpenParen)
                            }
                            let value = scanner.scanInt()!
                            tokens.append(.Number(value))
                            while let _ = scanner.scanString(")") {
                                tokens.append(.CloseParen)
                            }
                            return tokens
                    }
                })
                .joined()
            )
        })
}

func reduce(_ input: [Token]) -> Token {
    var value: Int
    switch input[0] {
        case .Number(let n):
                value = n
        default:
            fatalError()
    }
    
    var i = 1
    while i < input.count {
        let op = input[i]
        i += 1
        
        var otherValue: Int
        switch input[i] {
            case .Number(let n):
                otherValue = n
            default:
                fatalError()
        }
        i += 1
        
        switch op {
            case .Add:
                value += otherValue
            case .Multiply:
                value *= otherValue
            default:
                fatalError()
        }
    }
    return .Number(value)
}

func eval(_ input: [Token]) -> Int {
    var stack = [[Token]]()
    for token in input {
        switch token {
        case .Multiply:
            fallthrough
        case .Add:
            fallthrough
        case .Number(_):
            if stack.isEmpty {
                stack.append([token])
            } else {
                stack[stack.count - 1].append(token)
            }
        case .OpenParen:
            stack.append([])
        case .CloseParen:
            let closure = reduce(stack.popLast()!)
            if stack.isEmpty {
                stack.append([closure])
            } else {
                stack[stack.count - 1].append(closure)
            }
        }
    }
    if stack.count != 1 {
        fatalError()
    }

    switch reduce(stack.first!){
        case .Number(let n):
            return n
        default:
            fatalError()
    }
}

func part1(_ input: String) -> Int {
    return parseInput(input).reduce(0, { $0 + eval($1) })
}

try! test(part1("1 + 2 * 3 + 4 * 5 + 6") == 71, "part1")
try! test(part1("1 + (2 * 3) + (4 * (5 + 6))") == 51, "part1")
try! test(part1("2 * 3 + (4 * 5)") == 26, "part1")
try! test(part1("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 437, "part1")
try! test(part1("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 12240, "part1")
try! test(part1("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632, "part1")

let input = try! String(contentsOfFile: "input/day18.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
//print("\(part2(input))")
