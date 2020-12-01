import Foundation

public extension String {
    func indexAt(offset: Int) -> String.Index {
        return String.Index.init(utf16Offset: offset, in: self)
    }
    func characterAt(offset: Int) -> Character? {
        return self[self.indexAt(offset: offset)]
    }
    func asInt() -> Int? {
        return Int(self)
    }
}
