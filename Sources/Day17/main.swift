import Foundation
import Utils

func parseInput(_ input: String, dimensions: Int) -> MapND<Character> {
    let lines = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
    
    var map = MapND<Character>(dimensions: dimensions)
    for y in 0..<lines.count {
        let line = lines[y]
        for x in 0..<line.count {
            var coordiante = [Int](repeating:0, count:dimensions)
            coordiante[0] = x
            coordiante[1] = y
            map.set(coordinate: MapNDCoord(coordinates: coordiante), value: line.characterAt(offset: x)!)
        }
    }
    return map
}

func part1(_ input: String) -> Int {
    let starting = parseInput(input, dimensions: 3)
    
    var map: MapND<Character> = starting
    for _ in 1...6 {
        var nextMap = MapND<Character>(dimensions: 3)
        
        for z in map.mins[2]-1...map.maxes[2]+1 {
            for y in map.mins[1]-1...map.maxes[1]+1 {
                for x in map.mins[0]-1...map.maxes[0]+1 {
                    let current = MapNDCoord(coordinates: [x, y, z])
                    let adjacent = current.neighbours()
                    
                    let active = adjacent.reduce(0, {
                        guard let value = map.get($1) else {
                            return $0
                        }
                        return value == "#" ? $0 + 1 : $0
                    })
                    
                    let currentValue = map.get(current)
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
                    nextMap.set(coordinate: current, value: nextValue)
                }
            }
        }
        map = nextMap
    }
    
    var active = 0
    for z in map.mins[2]...map.maxes[2] {
        for y in map.mins[1]...map.maxes[1] {
            for x in map.mins[0]...map.maxes[0] {
                let current = MapNDCoord(coordinates: [x, y, z])
                let currentValue = map.get(current)
                if currentValue == "#" {
                    active += 1
                }
            }
        }
    }
    return active
}

try! test(part1("""
.#.
..#
###
""") == 112, "part1")

func part2(_ input: String) -> Int {
    let starting = parseInput(input, dimensions: 4)
    
    var map: MapND<Character> = starting
    for _ in 1...6 {
        var nextMap = MapND<Character>(dimensions: 4)
        
        for w in map.mins[3]-1...map.maxes[3]+1 {
            for z in map.mins[2]-1...map.maxes[2]+1 {
                for y in map.mins[1]-1...map.maxes[1]+1 {
                    for x in map.mins[0]-1...map.maxes[0]+1 {
                        let current = MapNDCoord(coordinates: [x, y, z, w])
                        let adjacent = current.neighbours()
                        
                        let active = adjacent.reduce(0, {
                            guard let value = map.get($1) else {
                                return $0
                            }
                            return value == "#" ? $0 + 1 : $0
                        })
                        
                        let currentValue = map.get(current)
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
                        nextMap.set(coordinate: current, value: nextValue)
                    }
                }
            }
        }
        map = nextMap
    }
    
    var active = 0
    for w in map.mins[3]...map.maxes[3] {
        for z in map.mins[2]...map.maxes[2] {
            for y in map.mins[1]...map.maxes[1] {
                for x in map.mins[0]...map.maxes[0] {
                    let current = MapNDCoord(coordinates: [x, y, z, w])
                    let currentValue = map.get(current)
                    if currentValue == "#" {
                        active += 1
                    }
                }
            }
        }
    }
    return active
}

try! test(part2("""
.#.
..#
###
""") == 848, "part2")

let input = try! String(contentsOfFile: "input/day17.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
