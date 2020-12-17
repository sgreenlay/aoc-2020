public struct MapNDCoord : Hashable {
    public var coordinates: Array<Int>

    public init(coordinates: Array<Int>) {
        self.coordinates = coordinates
    }
    
    public static func cartesianDirections(dimensions: Int) -> [MapNDCoord] {
        var coordinates = [[0],[1],[-1]]
        for _ in 1..<dimensions {
            var nextCoordinates = [[Int]]()
            for coordinate in coordinates {
                var nextCoordinate = coordinate

                nextCoordinate.append(0)
                nextCoordinates.append(nextCoordinate)
                
                nextCoordinate[nextCoordinate.count - 1] = 1
                nextCoordinates.append(nextCoordinate)
                
                nextCoordinate[nextCoordinate.count - 1] = -1
                nextCoordinates.append(nextCoordinate)
            }
            coordinates = nextCoordinates
        }
        coordinates.remove(at: 0)
        return coordinates.map({ MapNDCoord(coordinates: $0) })
    }
    
    public func neighbours() -> [MapNDCoord] {
        return MapNDCoord.cartesianDirections(dimensions: coordinates.count).map({ $0 + self })
    }

    public static func ==(lhs: MapNDCoord, rhs: MapNDCoord) -> Bool {
        assert(lhs.coordinates.count == rhs.coordinates.count)
        for n in 0..<lhs.coordinates.count {
            if lhs.coordinates[n] != rhs.coordinates[n] {
                return false
            }
        }
        return true
    }

    public static func +=(lhs: inout MapNDCoord, rhs: MapNDCoord) {
        assert(lhs.coordinates.count == rhs.coordinates.count)
        for n in 0..<lhs.coordinates.count {
            lhs.coordinates[n] += rhs.coordinates[n]
        }
    }

    public static func +(lhs: MapNDCoord, rhs: MapNDCoord) -> MapNDCoord {
        assert(lhs.coordinates.count == rhs.coordinates.count)
        var nextCoord = [Int]()
        for n in 0..<lhs.coordinates.count {
            nextCoord.append(lhs.coordinates[n] + rhs.coordinates[n])
        }
        return MapNDCoord(coordinates: nextCoord)
    }
}

public struct MapND<T> {
    var data:[MapNDCoord:T] = [MapNDCoord:T]()

    public var dimensions: Int
    public var mins: [Int]
    public var maxes: [Int]

    public init(dimensions: Int) {
        self.dimensions = dimensions
        self.mins = [Int](repeating:0, count:dimensions)
        self.maxes = [Int](repeating:0, count:dimensions)
    }

    public func get(_ coord: MapNDCoord) -> T? {
        return data[coord]
    }

    public mutating func set(coordinate: MapNDCoord, value: T) {
        assert(coordinate.coordinates.count == dimensions)
        
        for n in 0..<dimensions {
            mins[n] = min(mins[n], coordinate.coordinates[n])
            maxes[n] = max(maxes[n], coordinate.coordinates[n])
        }
        data[coordinate] = value
    }
}
