import Foundation
import Utils

func parseInput(_ input: String) -> [Int] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .map({ $0.asInt()! })
}

func part1(_ input: String) -> String {
    var cups = parseInput(input)
    
    var selectedCup = cups[0]
    for i in 1...100 {
        var output = ""
        for cup in cups {
            if cup == selectedCup {
                output += "(\(cup)) "
            } else {
                output += "\(cup) "
            }
        }
        
        print("Move \(i)")
        print(output)
        print("")
        
        // The crab picks up the three cups that are immediately clockwise
        // of the current cup. They are removed from the circle; cup
        // spacing is adjusted as necessary to maintain the circle.
        var removed = [Int]()
        for _ in 1...3 {
            let selectedIndex = cups.firstIndex(of: selectedCup)!
            let remove = (selectedIndex + 1) % cups.count
            removed.append(cups.remove(at: remove))
        }
        
        // The crab selects a destination cup: the cup with a label equal
        // to the current cup's label minus one. If this would select one
        // of the cups that was just picked up, the crab will keep
        // subtracting one until it finds a cup that wasn't just picked up.
        // If at any point in this process the value goes below the lowest
        // value on any cup's label, it wraps around to the highest value
        // on any cup's label instead.
        var nextIndex: Int? = nil
        var subtract = 1
        while nextIndex == nil {
            var findValue = selectedCup - subtract
            if findValue <= 0 {
                findValue = cups.max()!
            }
            nextIndex = cups.firstIndex(of: findValue)
            subtract += 1
        }
        
        // The crab places the cups it just picked up so that they are
        // immediately clockwise of the destination cup. They keep the same
        // order as when they were picked up.
        cups.insert(contentsOf: removed, at: nextIndex! + 1)
        
        // The crab selects a new current cup: the cup which is immediately
        // clockwise of the current cup.
        let selectedIndex = cups.firstIndex(of: selectedCup)!
        selectedCup = cups[(selectedIndex + 1) % cups.count]
    }

    let selectedIndex = cups.firstIndex(of: 1)!
    
    var output = ""
    for i in 1..<cups.count {
        output += "\(cups[(selectedIndex + i) % cups.count])"
    }
    return output
}

try! test(part1("389125467") == "67384529", "part1")

let input = try! String(contentsOfFile: "input/day23.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
//print("\(part2(input))")
