import Foundation
import Utils

enum Instruction {
    case Acc(Int)
    case Jmp(Int)
    case Nop(Int)
    
    public func execute(pc: inout Int, acc: inout Int) {
        switch self {
            case .Acc(let val):
                acc += val
                pc += 1
                break;
            case .Jmp(let val):
                pc += val
                break;
            case .Nop(let val):
                pc += 1
                break;
        }
    }
    
    static func parse(_ input: String) -> Instruction {
        let scanner = Scanner(string: input)
        
        let instruction = scanner.scanUpToString(" ")!
        let value = scanner.scanInt()!
        
        switch instruction {
            case "acc":
                return Acc(value)
            case "jmp":
                return Jmp(value)
            case "nop":
                return Nop(value)
            default:
                fatalError()
        }
    }
}

func parseInput(_ input: String) -> [Instruction] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({ Instruction.parse($0) })
}

func part1(_ input: String) -> Int {
    let instructions = parseInput(input)
    
    var pc = 0
    var acc = 0
    
    var visited = Set<Int>()
    while !visited.contains(pc)
    {
        visited.insert(pc)
        instructions[pc].execute(pc: &pc, acc: &acc)
    }
    
    return acc
}

assert(part1("""
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
""") == 5)

func isInfinite(instructions: [Instruction]) -> (Bool, Int) {
    var pc = 0
    var acc = 0
    
    var visited = Set<Int>()
    while !visited.contains(pc)
    {
        visited.insert(pc)
        instructions[pc].execute(pc: &pc, acc: &acc)
        
        if pc >= instructions.count {
            return (false, acc)
        }
    }
    
    return (true, acc)
}

func part2(_ input: String) -> Int {
    var instructions = parseInput(input)
    
    for i in 0..<instructions.count {
        switch instructions[i] {
        case .Jmp(let val):
            instructions[i] = .Nop(val)
            let result = isInfinite(instructions: instructions)
            if !result.0 {
                return result.1
            }
            instructions[i] = .Jmp(val)
            break;
        case .Nop(let val):
            instructions[i] = .Jmp(val)
            let result = isInfinite(instructions: instructions)
            if !result.0 {
                return result.1
            }
            instructions[i] = .Nop(val)
            break;
        default:
            break;
        }
    }
    fatalError()
}

assert(part2("""
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
""") == 8)

let input = try! String(contentsOfFile: "input/day08.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
