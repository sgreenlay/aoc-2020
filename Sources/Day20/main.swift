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

struct SideMapping : Hashable {
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
    
    public init(top: Side, right: Side, bottom: Side, left: Side) {
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
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
    
    public func apply(mapping: SideMapping) -> Tile {
        var copy = map
        
        switch mapping {
            case SideMapping(top: .Top, right: .Right, bottom: .Bottom, left: .Left):
                break
            case SideMapping(top: .Bottom, right: .Right, bottom: .Top, left: .Left):
                copy.flip(x: false, y: true)
                break
            case SideMapping(top: .Top, right: .Left, bottom: .Bottom, left: .Right):
                copy.flip(x: true, y: false)
                break
            case SideMapping(top: .Bottom, right: .Left, bottom: .Top, left: .Right):
                copy.flip(x: true, y: true)
                break
            case SideMapping(top: .Left, right: .Top, bottom: .Right, left: .Bottom):
                copy.rotate(clockwise: 90)
                break
            case SideMapping(top: .Bottom, right: .Left, bottom: .Top, left: .Right):
                copy.rotate(clockwise: 180)
                break
            case SideMapping(top: .Right, right: .Bottom, bottom: .Left, left: .Top):
                copy.rotate(clockwise: 270)
                break
            case SideMapping(top: .Right, right: .Top, bottom: .Left, left: .Bottom):
                copy.rotate(clockwise: 90)
                copy.flip(x: false, y: true)
                break
            case SideMapping(top: .Left, right: .Bottom, bottom: .Right, left: .Top):
                copy.rotate(clockwise: 90)
                copy.flip(x: true, y: false)
                break
            default:
                fatalError()
        }
        
        return Tile(map: copy)
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

    return (tile.apply(mapping: sideMap), orientedLinks)
}

func mapFromTiles(_ tiles: [Int: Tile]) -> Map2D<Character> {
    let links = tileLinks(tiles)
    
    let corners = links.filter({ (id, orientations) in orientations.count == 2 })
    
    var id = corners.first!.key
    var top: Int? = nil
    var left: Int? = nil
    
    var rowStart = id

    var orientedTileLinks = [Int: Dictionary<Side, Int>]()
    var map = Map2D<Character>()
    
    var y = 0
    var x = 0
    
    let tileSize = tiles[id]!.map.width - 2
    
    while orientedTileLinks.count < tiles.count {
        var (orientedTile, orientedLinks) = orient(tiles[id]!, links: links[id]!, top: top, left: left)
        
        for y in orientedTile.map.minY...orientedTile.map.maxY {
            let _ = orientedTile.map.remove(coordinate: Map2DCoord(x: orientedTile.map.minX, y: y))!
            let _ = orientedTile.map.remove(coordinate: Map2DCoord(x: orientedTile.map.maxX, y: y))!
        }
        
        for x in orientedTile.map.minX...orientedTile.map.maxX {
            let _ = orientedTile.map.remove(coordinate: Map2DCoord(x: x, y: orientedTile.map.minY))!
            let _ = orientedTile.map.remove(coordinate: Map2DCoord(x: x, y: orientedTile.map.maxY))!
        }
        
        map.append(orientedTile.map, topLeft: Map2DCoord(x: x, y: y))
        x += tileSize
        
        orientedTileLinks[id] = orientedLinks

        let right = orientedTileLinks[id]![.Right]
        if right == nil {
            let next = orientedTileLinks[rowStart]![.Bottom]
            if next == nil {
                break
            } else {
                x = 0
                y += tileSize

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
                top = orientedTileLinks[top!]![.Right]
            }
            left = id

            id = right!
        }
    }

    return map
}

func removeDragons(_ map: inout Map2D<Character>, dragonMap: Map2D<Character>) -> Int {
    let dragonInstances = map.findInstancesOf(dragonMap, ignoreBlanks: true)
    if dragonInstances.count == 0 {
        return 0
    }
    
    for y in dragonMap.minY...dragonMap.maxY {
        for x in dragonMap.minX...dragonMap.maxX {
            let dragonCoord = Map2DCoord(x: x, y: y)
            if dragonMap.get(dragonCoord) != nil {
                let dx = x - dragonMap.minX
                let dy = y - dragonMap.minY
                for instance in dragonInstances {
                    let mapCoord = Map2DCoord(x: instance.x + dx, y: instance.y + dy)
                    map.set(coordinate: mapCoord, value: ".")
                }
            }
        }
    }
    return dragonInstances.count
}

func part2(_ input: String) -> Int {
    let tiles = parseInput(input)
    
    let dragon = """
                      #
    #    ##    ##    ###
     #  #  #  #  #  #
    """.components(separatedBy: "\n")

    var dragonMap = Map2D<Character>()
    for y in 0..<dragon.count {
        for x in 0..<dragon[y].count {
            let dragonTile = dragon[y].characterAt(offset: x)!
            if dragonTile != " " {
                dragonMap.set(coordinate: Map2DCoord(x: x, y: y), value: dragonTile)
            }
        }
    }
    
    var map = mapFromTiles(tiles)
    
    var dragons = 0
    for _ in [0, 90, 180, 270] {
        dragons += removeDragons(&map, dragonMap: dragonMap)

        dragonMap.flip(x: true, y: false)
        dragons += removeDragons(&map, dragonMap: dragonMap)
        
        dragonMap.flip(x: false, y: true)
        dragons += removeDragons(&map, dragonMap: dragonMap)
        
        dragonMap.flip(x: true, y: false)
        dragons += removeDragons(&map, dragonMap: dragonMap)

        dragonMap.flip(x: false, y: true)
        map.rotate(clockwise: 90)
    }
    
    return map.validCoordinates.filter({ map.get($0)! == "#" }).count
}

try! test(part2(testInput) == 273, "part2")

let input = try! String(contentsOfFile: "input/day20.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
