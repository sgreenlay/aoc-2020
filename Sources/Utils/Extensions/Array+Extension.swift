import Foundation

public extension Array {
    mutating func rotate(_ distance: Int) {
        self.insert(contentsOf: self.suffix(distance), at: 0)
        self.removeLast(distance)
    }
}
