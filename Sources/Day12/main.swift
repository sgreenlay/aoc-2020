import Foundation
import Utils

enum NavigationAction {
    case North(Int)
    case South(Int)
    case East(Int)
    case West(Int)
    case Left(Int)
    case Right(Int)
    case Forward(Int)
    
    static func parse(_ input: String) -> NavigationAction {
        let scanner = Scanner(string: input)
        
        let action = scanner.scanCharacter()!
        let value = scanner.scanInt()!
        
        switch action {
        case "N":
            return .North(value)
        case "S":
            return .South(value)
        case "E":
            return .East(value)
        case "W":
            return .West(value)
        case "L":
            return .Left(value)
        case "R":
            return .Right(value)
        case "F":
            return .Forward(value)
        default:
            fatalError()
        }
    }
}

func parseInput(_ input: String) -> [NavigationAction] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({ NavigationAction.parse($0) })
}

func part1(_ input: String) -> Int {
    let actions = parseInput(input)
    
    var location = Map2DCoord(x: 0, y: 0)
    var facing = Map2DCoord.east
    
    for action in actions {
        switch action {
            case .Right(let angle):
                facing.turn(clockwise: angle)
            case .Left(let angle):
                facing.turn(counterClockwise: angle)
            case .North(let distance):
                for _ in 0..<distance {
                    location += Map2DCoord.north
                }
            case .South(let distance):
                for _ in 0..<distance {
                    location += Map2DCoord.south
                }
            case .East(let distance):
                for _ in 0..<distance {
                    location += Map2DCoord.east
                }
            case .West(let distance):
                for _ in 0..<distance {
                    location += Map2DCoord.west
                }
            case .Forward(let distance):
                for _ in 0..<distance {
                    location += facing
                }
                break
        }
    }
    
    return location.manhattenDistance(Map2DCoord(x: 0, y: 0))
}

assert(part1("""
F10
N3
F7
R90
F11
""") == 25)

func rotateWaypoint(waypoint: inout Map2DCoord, counterClockwise: Int) {
    rotateWaypoint(waypoint: &waypoint, clockwise: -counterClockwise)
}

func rotateWaypoint(waypoint: inout Map2DCoord, clockwise: Int) {
    var relative = clockwise % 360
    if relative < 0 {
        relative += 360
    }

    let x = waypoint.x
    let y = waypoint.y
    
    switch relative {
        case 0:
            break
        case 90:
            waypoint.x = -y
            waypoint.y = x
            break
        case 180:
            waypoint.x = -x
            waypoint.y = -y
            break
        case 270:
            waypoint.x = y
            waypoint.y = -x
            break
        default:
            fatalError()
    }
}

func part2(_ input: String) -> Int {
    let actions = parseInput(input)
    
    var location = Map2DCoord(x: 0, y: 0)
    var waypoint = Map2DCoord(x: 10, y: -1)
    
    for action in actions {
        switch action {
            case .Right(let angle):
                rotateWaypoint(waypoint: &waypoint, clockwise: angle)
                break
            case .Left(let angle):
                rotateWaypoint(waypoint: &waypoint, counterClockwise: angle)
                break
            case .North(let distance):
                for _ in 0..<distance {
                    waypoint += Map2DCoord.north
                }
            case .South(let distance):
                for _ in 0..<distance {
                    waypoint += Map2DCoord.south
                }
            case .East(let distance):
                for _ in 0..<distance {
                    waypoint += Map2DCoord.east
                }
            case .West(let distance):
                for _ in 0..<distance {
                    waypoint += Map2DCoord.west
                }
            case .Forward(let distance):
                for _ in 0..<distance {
                    location += waypoint
                }
                break
        }
    }
    
    return location.manhattenDistance(Map2DCoord(x: 0, y: 0))
}

assert(part2("""
F10
N3
F7
R90
F11
""") == 286)

let input = try! String(contentsOfFile: "input/day12.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
