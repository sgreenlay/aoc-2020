import Foundation
import Utils

enum Side {
    case Top
    case Right
    case Bottom
    case Left
    
    public static let Sides = [
        Side.Top,
        Side.Right,
        Side.Bottom,
        Side.Left
    ]
    
    public func opposite() -> Side {
        switch self {
            case .Top:
                return .Bottom
            case .Bottom:
                return .Top
            case .Left:
                return .Right
            case .Right:
                return .Left
        }
    }
}

struct Tile {
    var map: Map2D<Character>
    
    public func getSide(_ side: Side) -> String {
        var mapSide = ""
        switch side {
            case .Top:
                for x in map.minX...map.maxX {
                    mapSide.append(map.get(Map2DCoord(x: x, y: map.minY))!)
                }
                break
            case .Right:
                for y in map.minY...map.maxY {
                    mapSide.append(map.get(Map2DCoord(x: map.maxX, y: y))!)
                }
                break
            case .Bottom:
                for x in map.minX...map.maxX {
                    mapSide.append(map.get(Map2DCoord(x: x, y: map.maxY))!)
                }
                break
            case .Left:
                for y in map.minY...map.maxY {
                    mapSide.append(map.get(Map2DCoord(x: map.minX, y: y))!)
                }
                break
        }
        return mapSide
    }
    
    public static func parse(_ input: String) -> (Int, Tile) {
        var lines = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
        
        let scanner = Scanner(string: lines.remove(at: 0))
        let _ = scanner.scanString("Tile ")!
        let id = scanner.scanInt()!
        
        var map = Map2D<Character>()
        for y in 0..<lines.count {
            for x in 0..<lines[y].count {
                map.set(coordinate: Map2DCoord(x: x, y: y), value: lines[y].characterAt(offset: x)!)
            }
        }
        return (id, Tile(map: map))
    }
}

func parseInput(_ input: String) -> [Int: Tile] {
    return Dictionary(uniqueKeysWithValues: input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n\n")
        .map({ Tile.parse($0) }))
}

func tileLinks(_ tiles: [Int: Tile]) -> Dictionary<Int, Dictionary<Side, Int>> {
    var adjacencies = Dictionary<String, [Int]>()
    for (id, tile) in tiles {
        for side in Side.Sides {
            let unflipped = tile.getSide(side)
            if adjacencies[unflipped] != nil {
                adjacencies[unflipped]!.append(id)
            } else {
                adjacencies[unflipped] = [id]
            }

            let flipped = String(unflipped.reversed())
            if adjacencies[flipped] != nil {
                adjacencies[flipped]!.append(id)
            } else {
                adjacencies[flipped] = [id]
            }
        }
    }
    adjacencies = adjacencies.filter({ (_, tileSides) in
        tileSides.count > 1
    })
    
    var tileOrientations = Dictionary<Int, Dictionary<Side, Int>>()
    for (id, _) in tiles {
        var tileOrientation = Dictionary<Side, Int>()
        for side in Side.Sides {
            let unflipped = tiles[id]!.getSide(side)
            let adjacentSides = adjacencies[unflipped]
            if adjacentSides != nil {
                let otherSide = adjacentSides!.filter({ $0 != id })
                if otherSide.count == 1 {
                    tileOrientation[side] = otherSide[0]
                } else {
                    fatalError()
                }
            }
        }
        tileOrientations[id] = tileOrientation
    }
    return tileOrientations
}

func part1(_ input: String) -> Int {
    let tiles = parseInput(input)
    
    let corners = tileLinks(tiles).filter({ (id, orientations) in orientations.count == 2 })
    return corners.reduce(1, { $0 * $1.key })
}

let testInput = """
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
"""

try! test(part1(testInput) == 20899048083289, "part1")

struct SideMapping {
    public var top: Side?
    public var right: Side?
    public var bottom: Side?
    public var left: Side?
    
    public init() {
        self.top = nil
        self.right = nil
        self.bottom = nil
        self.left = nil
    }
    
    public func map(side: Side) -> Side {
        switch side {
            case .Top:
                return self.top!
            case .Bottom:
                return self.bottom!
            case .Left:
                return self.left!
            case .Right:
                return self.right!
        }
    }
}

func orient(_ tile: Tile, links: Dictionary<Side, Int>, top: Int?, left: Int?) -> (Tile, Dictionary<Side, Int>) {
    var sideMap = SideMapping()
    
    if top == nil && left == nil {
        if links[.Bottom] == nil && links[.Right] == nil {
            sideMap.top = .Bottom
            sideMap.left = .Right
        } else if links[.Top] == nil && links[.Left] == nil {
            sideMap.top = .Top
            sideMap.left = .Left
        } else if links[.Top] == nil && links[.Right] == nil {
            sideMap.top = .Top
            sideMap.left = .Right
        } else if links[.Bottom] == nil && links[.Left] == nil {
            sideMap.top = .Bottom
            sideMap.left = .Left
        } else {
            fatalError()
        }
    } else if top == nil {
        let leftSides = Array(links.filter({ $0.value == left }))
        if leftSides.count != 1 {
            fatalError()
        }
        
        sideMap.left = leftSides[0].key
        
        if sideMap.left == .Top || sideMap.left == .Bottom {
            if links[.Left] == nil {
                sideMap.top = .Left
            } else if links[.Right] == nil {
                sideMap.top = .Right
            } else {
                fatalError()
            }
        } else {
            if links[.Top] == nil {
                sideMap.top = .Top
            } else if links[.Bottom] == nil {
                sideMap.top = .Bottom
            } else {
                fatalError()
            }
        }
    } else if left == nil {
        let topSides = Array(links.filter({ $0.value == top }))
        if topSides.count != 1 {
            fatalError()
        }
        
        sideMap.top = topSides[0].key
        
        if sideMap.top == .Top || sideMap.top == .Bottom {
            if links[.Left] == nil {
                sideMap.left = .Left
            } else if links[.Right] == nil {
                sideMap.left = .Right
            } else {
                fatalError()
            }
        } else {
            if links[.Top] == nil {
                sideMap.left = .Top
            } else if links[.Bottom] == nil {
                sideMap.left = .Bottom
            } else {
                fatalError()
            }
        }
    } else {
        let topSides = Array(links.filter({ $0.value == top }))
        if topSides.count != 1 {
            fatalError()
        }
        sideMap.top = topSides[0].key
        
        let leftSides = Array(links.filter({ $0.value == left }))
        if leftSides.count != 1 {
            fatalError()
        }
        sideMap.left = leftSides[0].key
    }
    
    sideMap.right = sideMap.left!.opposite()
    sideMap.bottom = sideMap.top!.opposite()
    
    var orientedLinks = Dictionary<Side, Int>()
    for side in Side.Sides {
        orientedLinks[side] = links[sideMap.map(side: side)]
    }
    
    // TODO: TILE
    
    return (tile, orientedLinks)
}

func mapFromTiles(_ tiles: [Int: Tile]) -> Map2D<Character>? {
    let links = tileLinks(tiles)
    
    let corners = links.filter({ (id, orientations) in orientations.count == 2 })

    var id = corners.first!.key
    var top: Int? = nil
    var left: Int? = nil
    
    var rowStart = id

    var orientedTileLinks = [Int: (Tile, Dictionary<Side, Int>)]()
    while orientedTileLinks.count < tiles.count {
        orientedTileLinks[id] = orient(tiles[id]!, links: links[id]!, top: top, left: left)

        let right = orientedTileLinks[id]!.1[.Right]
        if right == nil {
            let next = orientedTileLinks[rowStart]!.1[.Bottom]
            if next == nil {
                break
            } else {
                id = next!
                
                top = rowStart
                left = nil
                
                rowStart = id
            }
        } else {
            if orientedTileLinks[right!] != nil {
                fatalError()
            }

            if top != nil {
                top = orientedTileLinks[top!]!.1[.Right]
            }
            left = id

            id = right!
        }
    }

    return nil
}

func part2(_ input: String) -> Int {
    let tiles = parseInput(input)
    
    let map = mapFromTiles(tiles)
    return 0
}

try! test(part2(testInput) == 0 /*273*/, "part2")

let input = try! String(contentsOfFile: "input/day20.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
