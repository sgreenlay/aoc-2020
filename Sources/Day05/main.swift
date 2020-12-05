import Foundation
import Utils

func getSeatIds(_ input: String) -> [Int] {
    let sequences = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
    
    var seatIds = Array<Int>()
    for sequence in sequences {
        var row = Array(0...127)
        var col = Array(0...7)

        for ch in sequence {
            let halfRow = row.count / 2
            let halfCol = col.count / 2

            if ch == "F" {
                row.removeSubrange(halfRow..<row.count)
            } else if ch == "B" {
                row.removeSubrange(0..<halfRow)
            } else if ch == "L" {
                col.removeSubrange(halfCol..<col.count)
            } else if ch == "R" {
                col.removeSubrange(0..<halfCol)
            } else {
                fatalError()
            }
        }
        if row.count != 1 || col.count != 1 {
            fatalError()
        }
        
        let seatId = row.first! * 8 + col.first!
        seatIds.append(seatId)
    }
    return seatIds
}

func part1(_ input: String) -> Int {
    let seatIds = getSeatIds(input)
    return seatIds.max()!
}

assert(part1("FBFBBFFRLR") == 357)
assert(part1("BFFFBBFRRR") == 567)
assert(part1("FFFBBBFRRR") == 119)
assert(part1("BBFFBBFRLL") == 820)

func part2(_ input: String) -> Int {
    let seatIds = getSeatIds(input).sorted()
    
    for i in 0..<seatIds.count-1 {
        if seatIds[i+1] == seatIds[i] + 2 {
            return seatIds[i] + 1
        }
        if seatIds[i+1] != seatIds[i] + 1 {
            fatalError()
        }
    }
    fatalError()
}

let input = try! String(contentsOfFile: "input/day05.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
