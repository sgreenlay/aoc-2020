import Foundation
import Utils

func parseInput(_ input: String) -> [Int] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({ $0.asInt()! })
}

func getLoopSize(subjectNumber: Int, publicKey: Int) -> Int {
    var loopSize = 0
    
    /*
     To transform a subject number, start with the value 1.
     Then, a number of times called the loop size, perform the following steps:
     
     - Set the value to itself multiplied by the subject number.
     - Set the value to the remainder after dividing the value by 20201227.
     */
    
    var value = subjectNumber
    while value != publicKey {
        value *= subjectNumber
        value = value % 20201227
        loopSize += 1
    }
    
    return loopSize
}

func part1(_ input: String) -> Int {
    let keys = parseInput(input)

    let cardLoopSize = getLoopSize(subjectNumber: 7, publicKey: keys[0])
    let doorLoopSize = getLoopSize(subjectNumber: 7, publicKey: keys[1])
    
    print("card: \(cardLoopSize), door: \(doorLoopSize)")
    
    let subjectNumber = keys[1]
    var value = subjectNumber
    for _ in 1...cardLoopSize {
        value *= subjectNumber
        value = value % 20201227
    }
    return value
}

try! test(part1("""
5764801
17807724
""") == 14897079, "part1")

let input = try! String(contentsOfFile: "input/day25.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
