import Foundation
import Utils

enum Direction {
    case East
    case SouthEast
    case SouthWest
    case West
    case NorthWest
    case NorthEast
    
    static let Directions = [
        Direction.East,
        Direction.SouthEast,
        Direction.SouthWest,
        Direction.West,
        Direction.NorthWest,
        Direction.NorthEast
    ]
}

func parseInput(_ input: String) -> [[Direction]] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({
            var directions = [Direction]()
            
            var i = 0
            while i < $0.count {
                let current = $0.characterAt(offset: i)
                let next = (i == $0.count - 1) ? nil : $0.characterAt(offset: i + 1)
                
                switch current {
                    case "n":
                        switch next {
                            case "e":
                                directions.append(.NorthEast)
                            case "w":
                                directions.append(.NorthWest)
                            default:
                                fatalError()
                        }
                        i += 2
                    case "s":
                        switch next {
                            case "e":
                                directions.append(.SouthEast)
                            case "w":
                                directions.append(.SouthWest)
                            default:
                                fatalError()
                        }
                        i += 2
                    case "e":
                        directions.append(.East)
                        i += 1
                    case "w":
                        directions.append(.West)
                        i += 1
                    default:
                        fatalError()
                }
            }
            return directions
        })
}

struct HexCoord : Hashable {
    public var x: Int
    public var y: Int
    public var z: Int
    
    public func navigate(_ direction: Direction) -> HexCoord {
        switch direction {
            case .NorthWest:
                return HexCoord(x: self.x, y: self.y + 1, z: self.z - 1)
            case .NorthEast:
                return HexCoord(x: self.x + 1, y: self.y, z: self.z - 1)
            case .East:
                return HexCoord(x: self.x + 1, y: self.y - 1, z: self.z)
            case .SouthEast:
                return HexCoord(x: self.x, y: self.y - 1, z: self.z + 1)
            case .SouthWest:
                return HexCoord(x: self.x - 1, y: self.y, z: self.z + 1)
            case .West:
                return HexCoord(x: self.x - 1, y: self.y + 1, z: self.z)
        }
    }
    
    public func neighbours() -> [HexCoord] {
        return Direction.Directions.map({ self.navigate($0) })
    }
}

// https://www.redblobgames.com/grids/hexagons/#coordinates-cube
func coordinateFromDirections(directions: [Direction]) -> HexCoord {
    return directions.reduce(HexCoord(x:0, y:0, z:0), { $0.navigate($1) })
}

func getInitialState(_ tiles: [HexCoord]) -> Set<HexCoord> {
    var initialState = Set<HexCoord>()
    for tile in tiles {
        if initialState.contains(tile) {
            initialState.remove(tile)
        } else {
            initialState.insert(tile)
        }
    }
    return initialState
}

func part1(_ input: String) -> Int {
    let tilesToFlip = parseInput(input)
        .map({ coordinateFromDirections(directions: $0) })

    return getInitialState(tilesToFlip).count
}

try! test(part1("""
nwwswee
""") == 1, "part1")

try! test(part1("""
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
""") == 10, "part1")

func part2(_ input: String) -> Int {
    let tilesToFlip = parseInput(input)
        .map({ coordinateFromDirections(directions: $0) })

    var state = getInitialState(tilesToFlip)
    for _ in 1...100 {
        var nextState = Set<HexCoord>()
        
        var toCheck = Set<HexCoord>()
        for coord in state {
            toCheck.insert(coord)
            toCheck = toCheck.union(coord.neighbours())
        }

        for current in toCheck {
            let adjacentBlack = current.neighbours().reduce(0, {
                return state.contains($1) ? $0 + 1 : $0
            })
            
            if state.contains(current) {
                // Any black tile with zero or more than
                // 2 black tiles immediately adjacent to
                // it is flipped to white.
                if adjacentBlack == 1 || adjacentBlack == 2 {
                    nextState.insert(current)
                }
            } else {
                // Any white tile with exactly 2 black
                // tiles immediately adjacent to it is
                // flipped to black.
                if adjacentBlack == 2 {
                    nextState.insert(current)
                }
            }
        }
        state = nextState
    }
    return state.count
}

try! test(part2("""
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
""") == 2208, "part2")

let input = try! String(contentsOfFile: "input/day24.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
