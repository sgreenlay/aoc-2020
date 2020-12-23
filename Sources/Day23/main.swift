import Foundation
import Utils

func parseInput(_ input: String) -> [Int] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .map({ $0.asInt()! })
}

func runGame(startingCups: [Int], iterations: Int) -> [Int] {
    var cups = CircularBuffer<Int>(contentsOf: startingCups)
    
    var current = startingCups[0]
    for i in 1...iterations {
        // The crab picks up the three cups that are immediately clockwise
        // of the current cup. They are removed from the circle; cup
        // spacing is adjusted as necessary to maintain the circle.
        let removed = cups.remove(after: current, count: 3)

        // The crab selects a destination cup: the cup with a label equal
        // to the current cup's label minus one. If this would select one
        // of the cups that was just picked up, the crab will keep
        // subtracting one until it finds a cup that wasn't just picked up.
        // If at any point in this process the value goes below the lowest
        // value on any cup's label, it wraps around to the highest value
        // on any cup's label instead.
        var destination = current
        repeat {
            destination -= 1
            if destination == 0 {
                destination = startingCups.count
            }
        } while !cups.contains(destination)
        cups.insert(after: destination, contentsOf: removed)
        
        // The crab selects a new current cup: the cup which is immediately
        // clockwise of the current cup.
        current = cups.after(current)
    }
    
    return cups.toArray(startingWith: startingCups[0])
}

func part1(_ input: String) -> String {
    let startingCups = parseInput(input)
    let endingCups = runGame(startingCups: startingCups, iterations: 100)
    
    let selectedIndex = endingCups.firstIndex(of: 1)!

    var output = ""
    for i in 1..<endingCups.count {
        output += "\(endingCups[(selectedIndex + i) % endingCups.count])"
    }
    return output
}

try! test(part1("389125467") == "67384529", "part1")

func part2(_ input: String) -> Int {
    var startingCups = parseInput(input)
    for i in startingCups.count+1...1_000_000 {
        startingCups.append(i)
    }

    let endingCups = runGame(startingCups: startingCups, iterations: 10_000_000)
    
    let selectedIndex = endingCups.firstIndex(of: 1)!
    
    let nextTwo = [
        endingCups[(selectedIndex + 1) % endingCups.count],
        endingCups[(selectedIndex + 2) % endingCups.count]
    ]
    return nextTwo.reduce(1, *)
}

try! test(part2("389125467") == 149245887792, "part2")

let input = try! String(contentsOfFile: "input/day23.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
