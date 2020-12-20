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

struct TileSide : Hashable {
    public let id: Int
    public let side: Side
    public let flipped: Bool
}

func part1(_ input: String) -> Int {
    let tiles = parseInput(input)

    var tileSideMap = Dictionary<TileSide, String>()
    for (id, tile) in tiles {
        for side in Side.Sides {
            let unflipped = TileSide(id: id, side: side, flipped: false)
            tileSideMap[unflipped] = tile.getSide(side)
            
            let flipped = TileSide(id: id, side: side, flipped: true)
            tileSideMap[flipped] = String(tileSideMap[unflipped]!.reversed())
        }
    }
    
    var adjacencies = Dictionary<String, [TileSide]>()
    for (tileSide, side) in tileSideMap {
        if adjacencies[side] != nil {
            adjacencies[side]!.append(tileSide)
        } else {
            adjacencies[side] = [tileSide]
        }
    }
    adjacencies = adjacencies.filter({ (_, tileSides) in
        tileSides.count > 1
    })
    
    var tileOrientations = Dictionary<Int, [Dictionary<Side, TileSide>]>()
    for (id, _) in tiles {
        let configurations = [
            [
                TileSide(id: id, side: .Top, flipped: false),
                TileSide(id: id, side: .Left, flipped: false),
                TileSide(id: id, side: .Bottom, flipped: false),
                TileSide(id: id, side: .Right, flipped: false)
            ],
            [
                TileSide(id: id, side: .Top, flipped: true),
                TileSide(id: id, side: .Left, flipped: false),
                TileSide(id: id, side: .Bottom, flipped: true),
                TileSide(id: id, side: .Right, flipped: false)
            ],
            [
                TileSide(id: id, side: .Top, flipped: false),
                TileSide(id: id, side: .Left, flipped: true),
                TileSide(id: id, side: .Bottom, flipped: false),
                TileSide(id: id, side: .Right, flipped: true)
            ],
            [
                TileSide(id: id, side: .Top, flipped: true),
                TileSide(id: id, side: .Left, flipped: true),
                TileSide(id: id, side: .Bottom, flipped: true),
                TileSide(id: id, side: .Right, flipped: true)
            ]
        ]
        
        var mappings = [Dictionary<Side, TileSide>]()
        for configuation in configurations {
            var mapping = Dictionary<Side, TileSide>()
            for side in configuation {
                let adjacentSides = adjacencies[tileSideMap[side]!]
                if adjacentSides != nil {
                    let otherSide = adjacentSides!.filter({ $0.id != id })
                    if otherSide.count == 1 {
                        mapping[side.side] = otherSide[0]
                    } else {
                        fatalError()
                    }
                }
                
            }
            mappings.append(mapping)
        }
        
        tileOrientations[id] = mappings
    }
    
    let corners = tileOrientations.filter({ (id, orientations) in orientations[0].count == 2 })
    return corners.reduce(1, { $0 * $1.key })
}

try! test(part1("""
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
""") == 20899048083289, "part1")

let input = try! String(contentsOfFile: "input/day20.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
//print("\(part2(input))")
