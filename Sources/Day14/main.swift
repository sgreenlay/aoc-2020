import Foundation
import Utils

enum Input {
    case Mask(String)
    case Memory(Int, Int)
}

func parseInput(_ input: String) -> [Input] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({
            if $0.starts(with: "mask = ") {
                let mask = String($0.suffix(from: $0.indexAt(offset: "mask = ".count)))
                return .Mask(mask)
            } else if $0.starts(with: "mem[") {
                let scanner = Scanner(string: $0)
                
                let _ = scanner.scanString("mem[")!
                let memory = scanner.scanInt()!
                let _ = scanner.scanString("] = ")!
                let value = scanner.scanInt()!
                
                return .Memory(memory, value)
            } else {
                fatalError()
            }
        })
}

func part1(_ input: String) -> Int {
    let program = parseInput(input)
    
    var mask = ""
    var memory = Dictionary<Int, Int>()
    for instruction in program {
        switch instruction {
        case .Mask(let newMask):
            mask = newMask
        case .Memory(let location, let value):
            var maskedValue = 0
            for offset in stride(from: mask.count-1, through: 0,by: -1) {
                let i = mask.count - offset - 1
                let bit = (value >> i) & 0b1
                switch mask.characterAt(offset: offset) {
                    case "0":
                        break
                    case "1":
                        maskedValue += 1 << i
                    case "X":
                        maskedValue += bit << i
                    default:
                        fatalError()
                }
            }
            memory[location] = maskedValue
        }
    }
    return memory.values.reduce(0, +)
}

assert(part1("""
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
""") == 165)

func part2(_ input: String) -> Int {
    let program = parseInput(input)
    
    var mask = ""
    var memory = Dictionary<Int, Int>()
    for instruction in program {
        switch instruction {
        case .Mask(let newMask):
            mask = newMask
        case .Memory(let location, let value):
            var locations = [0]
            for offset in stride(from: mask.count-1, through: 0,by: -1) {
                let i = mask.count - offset - 1
                let bit = (location >> i) & 0b1
                switch mask.characterAt(offset: offset) {
                    case "0":
                        locations = locations.map({ $0 + bit << i })
                    case "1":
                        locations = locations.map({ $0 + 1 << i })
                    case "X":
                        var newLocations = Array<Int>()
                        for location in locations {
                            newLocations.append(location)
                            newLocations.append(location + 1 << i)
                        }
                        locations = newLocations
                    default:
                        fatalError()
                }
            }
            for location in locations {
                memory[location] = value
            }
        }
    }
    return memory.values.reduce(0, +)
}

assert(part2("""
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
""") == 208)

let input = try! String(contentsOfFile: "input/day14.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
