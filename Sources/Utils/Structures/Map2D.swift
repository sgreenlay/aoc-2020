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
        
        let x = self.x
        let y = self.y
        
        switch relative {
            case 0:
                break
            case 90:
                self.x = -y
                self.y = x
                break
            case 180:
                self.x = -x
                self.y = -y
                break
            case 270:
                self.x = y
                self.y = -x
                break
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

    public init() {
    }
    
    public var width: Int {
        return maxX - minX + 1
    }
    public var height: Int {
        return maxY - minY + 1
    }
    
    public var minX: Int {
        return data.keys.map({ $0.x }).min()!
    }
    public var maxX: Int {
        return data.keys.map({ $0.x }).max()!
    }
    public var minY: Int {
        return data.keys.map({ $0.y }).min()!
    }
    public var maxY: Int {
        return data.keys.map({ $0.y }).max()!
    }
    
    public var validCoordinates: [Map2DCoord] {
        return Array(data.keys)
    }

    public func get(_ coord: Map2DCoord) -> T? {
        return data[coord]
    }

    public mutating func set(coordinate: Map2DCoord, value: T) {
        data[coordinate] = value
    }
    
    public mutating func remove(coordinate: Map2DCoord) -> T? {
        return data.removeValue(forKey: coordinate) ?? nil
    }
    
    public mutating func append(_ other: Map2D<T>, topLeft: Map2DCoord? = nil) {
        for y in other.minY...other.maxY {
            for x in other.minX...other.maxX {
                var coord = Map2DCoord(x: x, y: y)
                let value = other.get(coord)
                
                if value != nil {
                    if topLeft != nil {
                        coord.x = topLeft!.x + x + (0 - other.minX)
                        coord.y = topLeft!.y + y + (0 - other.minY)
                    }
                    self.set(coordinate: coord, value: value!)
                }
            }
        }
    }
    
    public mutating func rotate(counterClockwise: Int) {
        rotate(clockwise: -counterClockwise)
    }
    
    public mutating func rotate(clockwise: Int) {
        var newData = [Map2DCoord:T]()

        for (coord, value) in data {
            var newCoord = coord
            newCoord.turn(clockwise: clockwise)
            
            newData[newCoord] = value
        }
        
        data = newData
    }
    
    public mutating func flip(x: Bool, y: Bool) {
        var newData = [Map2DCoord:T]()

        for (coord, value) in data {
            let newCoord = Map2DCoord(
                x: x ? -coord.x : coord.x,
                y: y ? -coord.y : coord.y
            )
            newData[newCoord] = value
        }
        
        data = newData
    }
}

public extension Map2D where T: Equatable {
    func findInstancesOf(_ other: Map2D<T>, ignoreBlanks: Bool = false) -> [Map2DCoord] {
        var instances = [Map2DCoord]()
        
        for y in self.minY...self.maxY {
            for x in self.minX...self.maxX {
                var isInstance = true
                findInstances: for otherY in other.minY...other.maxY {
                    for otherX in other.minX...other.maxX {
                        let otherCoord = Map2DCoord(x: otherX, y: otherY)
                        
                        let otherValue = other.get(otherCoord)
                        if otherValue == nil && ignoreBlanks {
                            continue
                        }
                        
                        let dx = otherCoord.x - other.minX
                        let dy = otherCoord.y - other.minY
                        
                        let selfCoord = Map2DCoord(x: x + dx, y: y + dy)
                        
                        let selfValue = self.get(selfCoord)
                        if otherValue != selfValue {
                            isInstance = false
                            break findInstances
                        }
                    }
                }
                if isInstance {
                    let topLeft = Map2DCoord(x: x, y: y)
                    instances.append(topLeft)
                }
            }
        }
        return instances
    }
}

public extension Map2D where T == Character {
    var description: String {
        var output = ""
        for y in self.minY...self.maxY {
            var line = ""
            for x in self.minX...self.maxX {
                let coord = Map2DCoord(x: x, y: y)
                let value = self.get(coord)
                
                if value == nil {
                    line.append(" ")
                } else {
                    line.append(value!)
                }
            }
            output += line + "\n"
        }
        return output
    }
}
