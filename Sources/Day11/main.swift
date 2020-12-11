import Foundation
import Utils

func parseInput(_ input: String) -> Map2D<Character> {
    let rows = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
    
    var map = Map2D<Character>()
    for y in 0..<rows.count {
        let row = rows[y]
        for x in 0..<row.count {
            map.set(coordinate: Map2DCoord(x: x, y: y), value: row.characterAt(offset: x)!)
        }
    }
    return map
}

func part1(_ input: String) -> Int {
    var map = parseInput(input)
    
    var changed = true
    while changed {
        changed = false

        let oldMap = map
        for y in map.minY...map.maxY {
            for x in map.minX...map.maxX {
                let current = Map2DCoord(x: x, y: y)
                let currentVal = oldMap.get(current)
                
                if currentVal == "." {
                    continue
                }
                
                let directions = [
                    Map2DCoord.upLeft,
                    Map2DCoord.up,
                    Map2DCoord.upRight,
                    Map2DCoord.right,
                    Map2DCoord.downRight,
                    Map2DCoord.down,
                    Map2DCoord.downLeft,
                    Map2DCoord.left
                ]
                
                var occupied = 0
                for direction in directions {
                    let val = oldMap.get(current + direction)
                    if val == "#" {
                        occupied += 1
                    }
                }
                
                // If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
                // If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
                // Otherwise, the seat's state does not change.
                
                if occupied == 0 {
                    if currentVal != "#" {
                        map.set(coordinate: current, value: "#")
                        changed = true
                    }
                } else if occupied >= 4 {
                    if currentVal != "L" {
                        map.set(coordinate: current, value: "L")
                        changed = true
                    }
                }
            }
        }
    }
    
    var seatCount = 0
    for y in map.minY...map.maxY {
        for x in map.minX...map.maxX {
            let current = Map2DCoord(x: x, y: y)
            let currentVal = map.get(current)
            
            if currentVal == "#" {
                seatCount += 1
            }
        }
    }
    
    return seatCount
}

assert(part1("""
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
""") == 37)

func part2(_ input: String) -> Int {
    var map = parseInput(input)
    
    var changed = true
    while changed {
        changed = false

        let oldMap = map
        for y in map.minY...map.maxY {
            for x in map.minX...map.maxX {
                let current = Map2DCoord(x: x, y: y)
                let currentVal = oldMap.get(current)
                
                if currentVal == "." {
                    continue
                }
                
                let directions = [
                    Map2DCoord.upLeft,
                    Map2DCoord.up,
                    Map2DCoord.upRight,
                    Map2DCoord.right,
                    Map2DCoord.downRight,
                    Map2DCoord.down,
                    Map2DCoord.downLeft,
                    Map2DCoord.left
                ]
                
                var occupied = 0
                for direction in directions {
                    var coord = current + direction
                    var val = oldMap.get(coord)
                    
                    while val != nil {
                        if val != "." {
                            if val == "#" {
                                occupied += 1
                            }
                            break
                        }
                        coord += direction
                        val = oldMap.get(coord)
                    }
                }
                
                if occupied == 0 {
                    if currentVal != "#" {
                        map.set(coordinate: current, value: "#")
                        changed = true
                    }
                } else if occupied >= 5 {
                    if currentVal != "L" {
                        map.set(coordinate: current, value: "L")
                        changed = true
                    }
                }
            }
        }
    }
    
    var seatCount = 0
    for y in map.minY...map.maxY {
        for x in map.minX...map.maxX {
            let current = Map2DCoord(x: x, y: y)
            let currentVal = map.get(current)
            
            if currentVal == "#" {
                seatCount += 1
            }
        }
    }
    
    return seatCount
}

assert(part2("""
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
""") == 26)

let input = try! String(contentsOfFile: "input/day11.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
