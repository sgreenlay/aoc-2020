import Foundation
import Utils

func parseInput(_ input: String) -> Map2D<Character> {
    let lines = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
    
    var map = Map2D<Character>()
    for y in 0..<lines.count {
        let line = lines[y]
        for x in 0..<line.count {
            map.set(coordinate: Map2DCoord(x: x, y: y), value: line.characterAt(offset: x)!)
        }
    }
    return map
}

func isActive(coord: Map2DCoord, level: Map2D<Character>) -> Bool {
    guard let value = level.get(coord) else {
        return false
    }
    return value == "#"
}

/*
func printLayer(level: Map2D<Character>) {
    for y in level.minY...level.maxY {
        var layer = ""
        for x in level.minX...level.maxX {
            layer.append(level.get(Map2DCoord(x: x, y: y))!)
        }
        print(layer)
    }
}
 */

func part1(_ input: String) -> Int {
    let starting = parseInput(input)
    
    /*
    print("Cycle \(0)")
    print("")
    printLayer(level: starting)
    print("")
     */
    
    var map: Array<Map2D<Character>> = [starting]

    for cycle in 1...6 {
        map.insert(Map2D<Character>(), at: 0)
        map.append(Map2D<Character>())

        var nextMap = Array<Map2D<Character>>()
        
        for z in 0..<map.count {
            var currentLevelNext = Map2D<Character>()
            
            let previousLevel = z > 0 ? map[z - 1] : nil
            let currentLevel = map[z]
            let nextLevel = z < map.count - 1 ? map[z + 1] : nil

            for y in starting.minY-cycle...starting.maxY+cycle {
                for x in starting.minX-cycle...starting.maxX+cycle {
                    let current = Map2DCoord(x: x, y: y)
                    let adjacent = Map2DCoord.cartesianDirections.map({ current + $0 })
                    
                    var active = adjacent.reduce(0, {
                        if isActive(coord: $1, level: currentLevel) {
                            return $0 + 1
                        }
                        return $0
                    })
                    if previousLevel != nil {
                        if isActive(coord: current, level: previousLevel!) {
                            active += 1
                        }
                        active += adjacent.reduce(0, {
                            if isActive(coord: $1, level: previousLevel!) {
                                return $0 + 1
                            }
                            return $0
                        })
                    }
                    if nextLevel != nil {
                        if isActive(coord: current, level: nextLevel!) {
                            active += 1
                        }
                        active += adjacent.reduce(0, {
                            if isActive(coord: $1, level: nextLevel!) {
                                return $0 + 1
                            }
                            return $0
                        })
                    }
                    
                    let currentValue = currentLevel.get(current)
                    var nextValue: Character = " "
                    
                    if currentValue != nil && currentValue == "#" {
                        // If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
                        if active == 2 || active == 3 {
                            nextValue = "#"
                        } else {
                            nextValue = "."
                        }
                    } else {
                        // If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.
                        if active == 3 {
                            nextValue = "#"
                        } else {
                            nextValue = "."
                        }
                    }
                    currentLevelNext.set(coordinate: current, value: nextValue)
                }
            }
            nextMap.append(currentLevelNext)
        }
        
        /*
        print("Cycle \(cycle)")
        print("")
        for z in 0..<nextMap.count {
            printLayer(level: nextMap[z])
            print("")
        }
         */
        
        map = nextMap
    }
    
    let active = map.reduce(0, { sum, level in
        var nextSum = sum
        for y in level.minY...level.maxY {
            for x in level.minX...level.maxX {
                if isActive(coord: Map2DCoord(x: x, y: y), level: level) {
                    nextSum += 1
                }
            }
        }
        return nextSum
    })
    return active
}

try! test(part1("""
.#.
..#
###
""") == 112, "part1")

let input = try! String(contentsOfFile: "input/day17.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
//print("\(part2(input))")
