public struct Map2DCoord: Hashable {
    public var x:Int
    public var y:Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public var description: String { 
        return "<x:\(self.x), y:\(self.y)>"
    }

    public func manhattenDistance(_ to: Map2DCoord) -> Int {
        return abs(self.x - to.x) + abs(self.y - to.y)
    }
    
    public mutating func turn(counterClockwise: Int) {
        turn(clockwise: -counterClockwise)
    }
    
    public mutating func turn(clockwise: Int) {
        var relative = clockwise % 360
        if relative < 0 {
            relative += 360
        }
        
        switch self {
            case Map2DCoord.north:
                switch relative {
                    case 0:
                        break
                    case 90:
                        self = Map2DCoord.east
                        break
                    case 180:
                        self = Map2DCoord.south
                        break
                    case 270:
                        self = Map2DCoord.west
                        break
                    default:
                        fatalError()
                }
            case Map2DCoord.east:
                switch relative {
                    case 0:
                        break
                    case 90:
                        self = Map2DCoord.south
                        break
                    case 180:
                        self = Map2DCoord.west
                        break
                    case 270:
                        self = Map2DCoord.north
                        break
                    default:
                        fatalError()
                }
            case Map2DCoord.south:
                switch relative {
                    case 0:
                        break
                    case 90:
                        self = Map2DCoord.west
                        break
                    case 180:
                        self = Map2DCoord.north
                        break
                    case 270:
                        self = Map2DCoord.east
                        break
                    default:
                        fatalError()
                }
            case Map2DCoord.west:
                switch relative {
                    case 0:
                        break
                    case 90:
                        self = Map2DCoord.north
                        break
                    case 180:
                        self = Map2DCoord.east
                        break
                    case 270:
                        self = Map2DCoord.south
                        break
                    default:
                        fatalError()
                }
            default:
                fatalError()
        }
    }

    public static let zero = Map2DCoord(x: 0, y: 0)

    public static let up = Map2DCoord(x: 0, y: -1)
    public static let down = Map2DCoord(x: 0, y: 1)
    public static let left = Map2DCoord(x: -1, y: 0)
    public static let right = Map2DCoord(x: 1, y: 0)

    public static let upLeft = Map2DCoord(x: -1, y: -1)
    public static let upRight = Map2DCoord(x: 1, y: -1)
    public static let downLeft = Map2DCoord(x: -1, y: 1)
    public static let downRight = Map2DCoord(x: 1, y: 1)
    
    public static let north = Map2DCoord(x: 0, y: -1)
    public static let south = Map2DCoord(x: 0, y: 1)
    public static let west = Map2DCoord(x: -1, y: 0)
    public static let east = Map2DCoord(x: 1, y: 0)
    
    public static let northWest = Map2DCoord(x: -1, y: -1)
    public static let northEast = Map2DCoord(x: 1, y: -1)
    public static let southWest = Map2DCoord(x: -1, y: 1)
    public static let southEast = Map2DCoord(x: 1, y: 1)
    
    public static let cardinalDirections = [
        Map2DCoord.up,
        Map2DCoord.right,
        Map2DCoord.down,
        Map2DCoord.left
    ]
    
    public static let cartesianDirections = [
        Map2DCoord.upLeft,
        Map2DCoord.up,
        Map2DCoord.upRight,
        Map2DCoord.right,
        Map2DCoord.downRight,
        Map2DCoord.down,
        Map2DCoord.downLeft,
        Map2DCoord.left
    ]

    public static func ==(lhs: Map2DCoord, rhs: Map2DCoord) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    public static func +=(lhs: inout Map2DCoord, rhs: Map2DCoord) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    public static func +(lhs: Map2DCoord, rhs: Map2DCoord) -> Map2DCoord {
        return Map2DCoord(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

public struct Map2D<T> {
    var data:[Map2DCoord:T] = [Map2DCoord:T]()

    public var minX = 0
    public var maxX = 0
    public var minY = 0
    public var maxY = 0

    public init() {
    }

    public func get(_ coord: Map2DCoord) -> T? {
        return data[coord]
    }

    public mutating func set(coordinate: Map2DCoord, value: T) {
        minX = min(minX, coordinate.x)
        maxX = max(maxX, coordinate.x)
        minY = min(minY, coordinate.y)
        maxY = max(maxY, coordinate.y)
        data[coordinate] = value
    }
}
